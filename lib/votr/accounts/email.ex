defmodule Votr.Accounts.Email do
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Accounts.Email
  alias Votr.Accounts.Principal
  alias Votr.Accounts.DN

  embedded_schema do
    field(:mail, :string)
    field(:label, :string)
    field(:status, :string)
    field(:seq, :integer)
    field(:subject_id, :integer)
  end

  def changeset(%Email{} = email, attrs) do
    email
    |> cast(attrs, [:subject_id, :sequence, :mail, :label, :status])
    |> validate_required([:subject_id, :mail, :status])
    |> validate_inclusion(:label, ["home", "work", "other"])
    |> validate_inclusion(:status, ["unverified", "valid", "invalid"])
  end

  def to_principal(%Email{} = email) do
    %Principal{
      id: email.id,
      subject_id: email.subject_id,
      kind: "email",
      seq: email.seq,
      hash: :crypto.hash(:sha512, email.mail),
      data:
        %{mail: email.mail, label: email.label, status: email.status}
        |> DN.to_string()
        |> AES.encrypt()
        |> Base.encode64(opts)
    }
  end

  def from_principal(%Principal{} = p) do
    dn =
      p.data
      |> Base.decode64()
      |> AES.decrypt()
      |> DN.parse()

    %Email{
      id: p.id,
      subject_id: p.subject_id,
      mail: dn.mail,
      label: dn.label,
      status: dn.status,
      seq: p.seq
    }
  end
end
