defmodule Votr.Election.Candidate do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "candidate" do
    # res will join to this table using id to give candidates resource values
    field(:ballot_id, :integer)
    field(:ext_id, :string)
    field(:withdrawn, :boolean)
    timestamps()
  end

  @doc false
  def changeset(candidate, attrs) do
    candidate
    |> cast(attrs, [])
    |> validate_required([])
  end
end
