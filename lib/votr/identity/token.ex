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
  alias Votr.AES

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:value, :string)
    field(:usage, :string)
    field(:expiry, :utc_datetime)
  end

  def select_by_id(id) do
    case from(Principal)
         |> where([kind: "token", id: ^id])
         |> Repo.all
         |> Enum.map(&Token.from_principal(&1))
         |> Enum.at(0, nil)
      do
      nil -> {:error, :not_found}
      email -> {:ok, email}
    end

    def changeset(attrs) do
      %Token{}
      |> cast(attrs, [:usage, :value, :expiry])
      |> validate_required([:usage])
      |> validate_inclusion(:usage, ["email", "password", "totp"])

      attrs
      |> Map.merge(
           %{
             kind: "token",
             value:
               %{
                 value: attrs.value,
                 usage: attrs.usage,
                 expiry: Date.to_iso8601(attrs.expiry)
               }
               |> DN.to_string()
               |> AES.encrypt()
               |> Base.encode64()
           }
         )
      |> Principal.changeset()
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
