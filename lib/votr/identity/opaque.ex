defmodule Votr.Identity.Opaque do
  @moduledoc """
  Opaque identity is just an SHA-256 hash.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.Opaque
  alias Votr.Identity.Principal

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:hash, :string)
  end

  def changeset(%Opaque{} = opaque, attrs) do
    opaque
    |> cast(attrs, [:subject_id, :hash])
    |> validate_required([:subject_id, :hash])
    |> Map.update(:version, 0, &(&1 + 1))
    |> to_principal
  end

  def to_principal(%Opaque{} = opaque) do
    %Principal{
      id: opaque.id,
      subject_id: opaque.subject_id,
      version: opaque.version,
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
      version: p.version,
      hash: p.hash
    }
  end
end
