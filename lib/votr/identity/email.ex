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
    field(:state, :string)
  end

  def select_by_id(id) do
    case Repo.get(Principal, ^id)
      do
      nil ->
        {:error, :not_found}
      email ->
        {:ok, Email.from_principal(email)}
    end
  end

  def select_by_address(address) do
    hash = :crypto.hash(:sha256, address)
           |> Base.encode64

    case from(Principal)
         |> where(hash: ^hash)
         |> Repo.all
         |> Enum.map(&Email.from_principal(&1))
         |> Enum.filter(fn e -> e.address == address end)
         |> Enum.at(0, nil)
      do
      nil -> {:error, :not_found}
      email -> {:ok, email}
    end

  end

  def changeset(attrs \\ %{}) do
    %Email{}
    |> cast(attrs, [:seq, :address, :label, :state])
    |> validate_required([:seq, :address, :state])
    |> validate_inclusion(:label, ["home", "work", "other"])
    |> validate_inclusion(:state, ["invalid", "valid"])

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
      state: dn.state,
      seq: p.seq
    }
  end
end
