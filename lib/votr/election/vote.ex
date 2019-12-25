defmodule Votr.Election.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Election.Vote

  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "ballot_log" do
    belongs_to :ballot, Ballot
    field(:version, :integer)
    field(:voter_id, :integer) # an optional link to voter only when the ballot is mutable
    field(:weight, :integer)   # used to compact identical votes from multiple voters
    field(:value, :string)     # a vote rank string (eg. 3 4 1 2)
    timestamps()
  end

  def insert_all(subject_id, votes) do
    shard = FlexId.extract_partition(:id_generator, subject_id)

    all = votes
    |> Enum.map(
         fn ->
           %Vote{id: FlexId.generate(:id_generator, shard), version: 0, weight: 1}
           |> cast(votes, [:ballot_id, :voter_id, :value])
           |> validate_required([:id, :ballot_id, :version, :weight, :value])
         end
       )
    Repo.insert_all Vote, all, on_conflict: :replace_all, conflict_target: [:ballot_id, :voter_id]
  end

  def select_values(ballot_id) do
    results =
      "select value from vote where ballot_id = $1"
      |> Votr.Repo.stream(ballot_id)

    results.rows
    |> Enum.map(fn row -> row[0] end)
  end
end
