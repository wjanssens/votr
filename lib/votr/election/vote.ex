defmodule Votr.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "ballot_log" do
    field(:ballot_id, :integer)
    field(:version, :integer)
    field(:voter_id, :integer) # an optional link to voter only when the ballot is mutable
    field(:weight, :integer)   # used to compact identical votes from multiple voters
    field(:value, :string)     # a vote rank string (eg. 3 4 1 2)
    timestamps()
  end

  @doc false
  def changeset(ballot_log, attrs) do
    ballot_log
    |> cast(attrs, [:ballot_id, :voter_id, :value])
    |> validate_required([:ballot_id, :value])
  end

  def select_values(ballot_id) do
    results =
      "select value from vote where ballot_id = $1"
      |> Votr.Repo.stream(ballot_id)

    results.rows
    |> Enum.map(fn row -> row[0] end)
  end
end
