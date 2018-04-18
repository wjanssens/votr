defmodule Votr.Identity.CreditCard do
  @moduledoc """
  Credit cards may be retained for subjects that need to pay for their election results.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.CreditCard
  alias Votr.Identity.Principal
  alias Votr.Identity.DN
  alias Votr.AES

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:seq, :integer)
    field(:number, :string)
    field(:exp, :date)
  end

  def changeset(%CreditCard{} = card, attrs) do
    card
    |> cast(attrs, [:subject_id, :seq, :number, :exp])
    |> validate_required([:subject_id, :seq, :number, :exp])
    |> Map.update(:version, 0, &(&1 + 1))
    |> to_principal
  end

  def to_principal(%CreditCard{} = card) do
    %Principal{
      id: card.id,
      subject_id: card.subject_id,
      kind: "credit_card",
      seq: card.seq,
      hash: :crypto.hash(:sha512, card.number),
      value:
        %{
          number: card.number,
          exp: Date.to_iso8601(card.exp)
        }
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

    %CreditCard{
      id: p.id,
      subject_id: p.subject_id,
      number: dn.number,
      exp: Date.from_iso8601(dn.exp),
      seq: p.seq
    }
  end
end
