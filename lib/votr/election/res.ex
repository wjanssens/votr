defmodule Votr.Election.Res do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "res" do
    field(:parent_id, :string)
    field(:version, :integer)
    field(:tag, :string)
    field(:key, :string)
    field(:value, :string)
    timestamps()
  end

  @doc false
  def changeset(res, attrs) do
    res
    |> cast(attrs, [])
    |> validate_required([])
  end

  def select(entity_ids) do
    Res
    |> where("entity_id" in ^entity_ids)
    |> order_by(:parent_id)
    |> Votr.Repo.all()
  end
end
