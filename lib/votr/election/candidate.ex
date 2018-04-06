defmodule Votr.Election.Candidate do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "candidate" do
    # res will join to this table using id to give candidates resource values
    field(:ballot_id, :integer)
    field(:version, :integer)
    field(:ext_id, :string)
    field(:withdrawn, :boolean)
    field(:color, :string)
    timestamps()
  end

  @doc false
  def changeset(candidate, attrs) do
    candidate
    |> cast(attrs, [])
    |> validate_required([])
  end

  def select(ids) do
    Candidate
    |> Ecto.Query.where("ballot_id" in ^ids)
    |> Ecto.Query.order_by([:ballot_id, :seq])
    |> Votr.Repo.all()
  end
end
