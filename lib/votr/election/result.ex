defmodule Votr.Election.Result do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "result" do
    field(:ward_id, :integer)
    field(:round, :integer)
    field(:status, :string)
    field(:votes, :float)
    field(:surplus, :float)
    field(:exhausted, :float)
    timestamps()
  end

  @doc false
  def changeset(result, attrs) do
    result
    |> cast(attrs, [])
    |> validate_required([])
  end
end
