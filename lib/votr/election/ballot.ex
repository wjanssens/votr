defmodule Votr.Election.Ballot do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "ballot" do
    field(:id, :integer)
    field(:ward_id, :integer)
    field(:res_id, :integer)
    field(:kind, :string)
    field(:elect, :integer)
    field(:shuffle, :boolean)
    field(:mutable, :boolean)
    timestamps()
  end

  @doc false
  def changeset(ballot, attrs) do
    ballot
    |> cast(attrs, [])
    |> validate_required([])
  end
end
