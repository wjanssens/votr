defmodule Votr.Identity.Email do
  @moduledoc """
  Email addresses may be used to communicate with election officials.
  Email addresses may be used to deliver ballots to voters.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.Email
  alias Votr.Identity.Principal
  alias Votr.Identity.DN

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:seq, :integer)
    field(:address, :string)
    field(:label, :string)
    field(:failures, :integer)
  end

  def changeset(%Email{} = email, attrs) do
    email
    |> cast(attrs, [:subject_id, :seq, :address, :label, :failures])
    |> validate_required([:subject_id, :seq, :address, :failures])
    |> validate_inclusion(:label, ["home", "work", "other"])
    |> Map.update(:version, 0, &(&1 + 1))
    |> to_principal
  end

  def to_principal(%Email{} = email) do
    %Principal{
      id: email.id,
      subject_id: email.subject_id,
      kind: "email",
      seq: email.seq,
      hash: :crypto.hash(:sha512, email.mail),
      value:
        %{address: email.address, label: email.label, failures: Integer.to_string(email.failures)}
        |> DN.to_string()
        |> AES.encrypt()
        |> Base.encode64(opts)
    }
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
