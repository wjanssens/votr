defmodule Votr.Identity.PostalAddress do
  @moduledoc """
  Postal addresses may be used to deliver ballots to voters.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.PostalAddress
  alias Votr.Identity.Principal
  alias Votr.Identity.DN
  alias Votr.AES

  embedded_schema do
    field(:lines, {:array, :string})
    field(:label, :string)
    field(:status, :string)
    field(:seq, :integer)
    field(:subject_id, :integer)
  end

  def changeset(%PostalAddress{} = address, attrs) do
    address
    |> cast(attrs, [:subject_id, :sequence, :lines, :label, :status])
    |> validate_required([:subject_id, :lines, :status])
    |> validate_inclusion(:label, ["home", "work", "other"])
    |> validate_inclusion(:status, ["unverified", "valid", "invalid"])
  end

  def to_principal(%PostalAddress{} = address) do
    lines =
      address.lines
      |> Enum.map(fn l -> String.replace(l, "\\", "\\\\") end)
      |> Enum.map(fn l -> String.replace(l, "$", "\$") end)
      |> Enum.join("$")

    %Principal{
      id: address.id,
      subject_id: address.subject_id,
      kind: "postal_address",
      seq: address.seq,
      value:
        %{postalAddress: lines, label: address.label, status: address.status}
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

    lines =
      dn.postalAddress
      |> String.split("$")
      |> Map.map(fn l -> String.replace(l, "\$", "$") end)
      |> Map.map(fn l -> String.replace(l, "\\\\", "\\") end)

    %PostalAddress{
      id: p.id,
      subject_id: p.subject_id,
      lines: lines,
      label: dn.label,
      status: dn.status,
      seq: p.seq
    }
  end
end
