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
    field(:hash, :string)
  end

  def changeset(%Opaque{} = opaque, attrs) do
    opaque
    |> cast(attrs, [:subject_id, :hash])
    |> validate_required([:subject_id, :hash])
  end

  def to_principal(%Opaque{} = opaque) do
    %Principal{
      id: opaque.id,
      subject_id: opaque.subject_id,
      kind: "opaque",
      seq: opaque.seq,
      hash: opaque.hash,
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
