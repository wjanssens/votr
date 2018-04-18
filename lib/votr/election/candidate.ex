defmodule Votr.Election.Candidate do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "candidate" do
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
    |> cast(attrs, [:ballot_id, :version, :ext_id, :withdrawn, :color])
    |> validate_required([:ballot_id, :version, :withdrawn])
  end

  def select(ids) do
    Candidate
    |> where("ballot_id" in ^ids)
    |> order_by([:ballot_id, :seq])
    |> Votr.Repo.all()
  end
end
