defmodule Votr.Identity.Token do
  @moduledoc """
  Tokens are temporary values used to identify long running conversations
  The key is a random value.
  The usage is how the key is to be used
  Supported usages are:
  - "phone": for phone number sms verification
  - "email": for new email address verification
  - "password": for password reset
  - "totp": for totp enrollment
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.Token
  alias Votr.Identity.Principal
  alias Votr.Identity.DN

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:key, :string)
    field(:value, :string)
    field(:usage, :string)
    field(:expiry, :date)
  end

  def select(key) do
    """
    select * from principal
    where kind = 'token' and hash = $1
    """
    |> Votr.Repo.query(token, :crypto.hash(:sha512, key))
    |> from_principal
    |> Enum.filter(fn t -> t.key == key end)
    |> Enum.at(0, nil)
  end

  def changeset(%Token{} = token, attrs) do
    card
    |> cast(attrs, [:subject_id, :key])
    |> validate_required([:subject_id, :key, :usage])
    |> validate_inclusion(:usage, ["email", "password", "totp"])
    |> Map.update(:version, 0, &(&1 + 1))
    |> to_principal
  end

  def to_principal(%Token{} = token) do
    %Principal{
      id: token.id,
      version: token.version,
      subject_id: token.subject_id,
      kind: "token",
      seq: nil,
      hash: :crypto.hash(:sha512, token.key),
      value:
        %{
          key: token.key,
          value: token.value,
          usage: token.usage,
          expiry: Date.to_iso8601(token.expiry)
        }
        |> DN.to_string()
        |> AES.encrypt()
        |> Base.encode64()
    }
  end

  def from_principal(%Principal{} = p) do
    dn =
      p.value
      |> Base.decode64()
      |> AES.decrypt()
      |> DN.from_string()

    %Token{
      id: p.id,
      subject_id: p.subject_id,
      version: p.version,
      key: dn.key,
      value: dn.value,
      usage: dn.usage,
      expiry: Date.from_iso8601(dn.expiry)
    }
  end
end
