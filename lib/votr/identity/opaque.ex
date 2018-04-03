defmodule Votr.Identity.Opaque do
  @moduledoc """
  Opaque identity is just an SHA-512 hash.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.IdentityCard
  alias Votr.Identity.Principal
  alias Votr.Identity.DN

  embedded_schema do
    field(:subject_id, :integer)
    field(:seq, :integer)
    field(:hash, :string)
  end

  def changeset(%IdentityCard{} = card, attrs) do
    card
    |> cast(attrs, [:subject_id, :seq, :number, :exp, :dob, :c, :st, :gn, :sn, :gender])
    |> validate_required([:subject_id, :seq, :number])
  end

  def to_principal(%Opaque{} = o) do
    %Principal{
      id: ic.id,
      subject_id: ic.subject_id,
      kind: "opaque",
      seq: ic.seq,
      hash: o.hash,
      value: nil
    }
  end

  def from_principal(%Principal{} = p) do
    %Opaque{
      id: p.id,
      subject_id: p.subject_id,
      seq: p.seq,
      hash: p.hash
    }
  end
end
