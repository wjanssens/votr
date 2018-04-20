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
  alias Votr.Identity.Token
  alias Votr.Identity.Principal
  alias Votr.Identity.DN
  alias Votr.AES

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:value, :string)
    field(:usage, :string)
    field(:expiry, :utc_datetime)
  end

  def select(id) do
    Principal.select(id, &from_principal/1)
  end

  def insert(subject_id, usage, value, expiry) do
    %Token{
      subject_id: subject_id,
      usage: usage,
      value: value,
      expiry: expiry
    }
    |> insert()
  end

  def insert(%Token{} = t) do
    to_principal(t)
    |> Principal.insert(&from_principal/1)
  end

  def to_principal(%Token{} = t) do
    %Principal{
      id: t.id,
      subject_id: t.subject_id,
      kind: "token",
      value:
        %{
          value: t.value,
          usage: t.usage,
          expiry: Date.to_iso8601(t.expiry)
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
      value: dn.value,
      usage: dn.usage,
      expiry: Date.from_iso8601(dn.expiry)
    }
  end
end
