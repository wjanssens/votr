defmodule Votr.Accounts.Phone do
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Accounts.Phone
  alias Votr.Accounts.Principal
  alias Votr.Accounts.DN

  embedded_schema do
    field(:number, :string)
    field(:label, :string)
    field(:status, :string)
    field(:seq, :integer)
    field(:subject_id, :integer)
  end

  def changeset(%Phone{} = phone, attrs) do
    phone
    |> cast(attrs, [:subject_id, :sequence, :mail, :label, :status])
    |> validate_required([:subject_id, :mail, :status])
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
  end

  def to_principal(%Phone{} = phone) do
    %Principal{
      id: phone.id,
      subject_id: phone.subject_id,
      kind: "phone",
      seq: phone.seq,
      hash: :crypto.hash(:sha512, phone.number),
      data:
        %{number: phone.number, label: phone.label, status: phone.status}
        |> DN.to_string()
        |> AES.encrypt()
        |> Base.encode64()
    }
  end

  def from_principal(%Principal{} = p) do
    dn =
      p.data
      |> Base.decode64()
      |> AES.decrypt()
      |> DN.parse()

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
