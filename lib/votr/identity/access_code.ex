defmodule Votr.Identity.AccessCode do
  @moduledoc """
  Access codes
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.AccessCode
  alias Votr.Identity.Principal
  alias Votr.Identity.DN
  alias Votr.AES

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:seq, :integer)
    field(:number, :string)
  end

  def changeset(%AccessCode{} = card, attrs) do
    card
    |> cast(attrs, [:subject_id, :seq, :number])
    |> validate_required([:subject_id, :seq, :number])
    |> Map.update(:version, 0, &(&1 + 1))
    |> to_principal
  end

  def to_principal(%AccessCode{} = ac) do
    %Principal{
      id: ac.id,
      subject_id: ac.subject_id,
      kind: "access_code",
      seq: ac.seq,
      hash: :crypto.hash(:sha256, ac.number)
            |> Base.encode64,
      value:
        ac.number
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

    %AccessCode{
      id: p.id,
      subject_id: p.subject_id,
      seq: p.seq,
      number: dn.number
    }
  end
end
