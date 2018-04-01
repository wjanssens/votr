defmodule Votr.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "ballot_log" do
    # voter_id is an optional link to voter only when the ballot is mutable
    field(:ballot_id, :integer)
    field(:voter_id, :integer)
    field(:value, :string)
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
    |> Enum.map(&(&[0]))
  end
end
