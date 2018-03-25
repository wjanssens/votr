defmodule Votr.Election.Ward do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "ward" do
    # res will join to this table using id to give wards resource values
    field(:parent_id, :integer)
    field(:res_id, :integer)
    field(:name, :string)
    timestamps()
  end

  @doc false
  def changeset(election, attrs) do
    election
    |> cast(attrs, [])
    |> validate_required([])
  end
end
