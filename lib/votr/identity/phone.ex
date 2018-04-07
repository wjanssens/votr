defmodule Votr.Identity.Phone do
  @moduledoc """
  Phone numbers may be used to communicate with election officials.
  Phone numbers may be used to deliver ballots to voters (via SMS).
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.Phone
  alias Votr.Identity.Principal
  alias Votr.Identity.DN

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:seq, :integer)
    field(:number, :string)
    field(:label, :string)
    field(:status, :string)
  end

  def changeset(%Phone{} = phone, attrs) do
    phone
    |> cast(attrs, [:subject_id, :seq, :number, :label, :status])
    |> validate_required([:subject_id, :number, :label, :status])
    |> validate_inclusion(:label, [
      "mobile",
      "iphone",
      "home",
      "work",
      "main",
      "home fax",
      "work fax",
      "other fax",
      "pager",
      "other"
    ])
    |> validate_inclusion(:status, ["unverified", "valid", "invalid"])
    |> Map.update(:version, 0, &(&1 + 1))
    |> to_principal
  end

  def to_principal(%Phone{} = phone) do
    %Principal{
      id: phone.id,
      subject_id: phone.subject_id,
      kind: "phone",
      seq: phone.seq,
      hash: :crypto.hash(:sha512, phone.number),
      value:
        %{number: phone.number, label: phone.label, status: phone.status}
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

    %Phone{
      id: p.id,
      subject_id: p.subject_id,
      number: dn.number,
      label: dn.label,
      status: dn.status,
      seq: p.seq
    }
  end
end
