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
  alias Votr.AES

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:seq, :integer)
    field(:number, :string)
    field(:label, :string)
    field(:status, :string)
  end

  def select_by_id(id) do
    Principal.select(id, &from_principal/1)
  end

  def update(%Phone{} = phone) do
    phone
    |> to_principal
    |> Principal.change(&from_principal/1)
  end

  def to_principal(%Phone{} = phone) do
    %Principal{
      id: phone.id,
      subject_id: phone.subject_id,
      version: phone.version,
      kind: "phone",
      seq: phone.seq,
      hash: :crypto.hash(:sha256, phone.number)
            |> Base.encode64,
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
      version: p.version,
      number: dn.number,
      label: dn.label,
      status: dn.status,
      seq: p.seq
    }
  end
end
