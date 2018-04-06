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
    field(:key, :string)
    field(:usage, :string)
    field(:expiry, :date)
  end

  def changeset(%Token{} = token, attrs) do
    card
    |> cast(attrs, [:subject_id, :key])
    |> validate_required([:subject_id, :key, :usage])
    |> validate_inclusion(:usage, ["email", "password", "totp"])
  end

  def to_principal(%Token{} = token) do
    %Principal{
      id: token.id,
      subject_id: token.subject_id,
      kind: "token",
      seq: nil,
      hash: :crypto.hash(:sha512, token.key),
      value:
        %{key: token.key, usage: token.usage, expiry: Date.to_iso8601(token.expiry)}
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
      key: dn.key,
      usage: dn.usage,
      expiry: Date.from_iso8601(dn.expiry)
    }
  end
end
