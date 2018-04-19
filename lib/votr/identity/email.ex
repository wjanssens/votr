defmodule Votr.Identity.Email do
  @moduledoc """
  Email addresses may be used to communicate with election officials.
  Email addresses may be used to deliver ballots to voters.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query #, only: [from: 2, where: 3]
  alias Votr.Identity.Email
  alias Votr.Identity.Principal
  alias Votr.Identity.DN
  alias Votr.AES
  alias Votr.Repo

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:seq, :integer)
    field(:address, :string)
    field(:label, :string)
    field(:failures, :integer)
  end

  def select(address) do
    hash = :crypto.hash(:sha256, address)
           |> Base.encode64

    from(Principal)
    |> where(hash: ^hash)
    |> Repo.all
    |> Enum.map(&Email.from_principal(&1))
    |> Enum.filter(fn e -> e.address == address end)
    |> Enum.at(0, nil)
  end

  def changeset(attrs \\ %{}) do
    %Email{}
    |> cast(attrs, [:seq, :address, :label, :failures])
    |> validate_required([:seq, :address, :failures])
    |> validate_inclusion(:label, ["home", "work", "other"])

    attrs
    |> Map.merge(
         %{
           kind: "email",
           value: %{address: attrs.address, label: attrs.label, failures: Integer.to_string(attrs.failures)}
                  |> DN.to_string()
                  |> AES.encrypt()
                  |> Base.encode64(),
           hash: :crypto.hash(:sha512, attrs.address)
                 |> Base.encode64
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

    %Email{
      id: p.id,
      subject_id: p.subject_id,
      address: dn.address,
      label: dn.label,
      failures: String.to_integer(dn.failures),
      seq: p.seq
    }
  end
end
