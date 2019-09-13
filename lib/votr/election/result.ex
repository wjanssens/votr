defmodule Votr.Election.Result do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "result" do
    belongs_to :ballot, Ballot
    field(:candidate_id, :integer)
    field(:version, :integer)
    field(:round, :integer)   # ballots are evaluated in rounds
    field(:status, :string)   # in each round a candidate is either elected or excluded
    field(:votes, :float)     # the number of votes obtained by the candidate in this round
    field(:surplus, :float)   # the number of surplus votes obtained by the candidate in this round
    field(:exhausted, :float) # the number of exhausted (can't transfer) in this round
    timestamps()
  end

  @doc false
  def changeset(result, attrs) do
    result
    |> cast(attrs, [])
    |> validate_required([])
  end
end
