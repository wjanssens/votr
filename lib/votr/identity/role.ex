defmodule Votr.Identity.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.Role
  alias Votr.Identity.Principal

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:name, :string)
  end

  def changeset(%Role{} = role, attrs) do
    card
    |> cast(attrs, [:subject_id, :key])
    |> validate_required([:subject_id, :name])
    |> Map.update(:version, 0, &(&1 + 1))
    |> to_principal
  end

  def to_principal(%Role{} = role) do
    %Principal{
      id: role.id,
      subject_id: role.subject_id,
      kind: "role",
      seq: nil,
      hash: nil,
      value: role.name
    }
  end

  def from_principal(%Principal{} = p) do
    %Role{
      id: p.id,
      subject_id: p.subject_id,
      name: p.value
    }
  end
end
