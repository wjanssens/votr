defmodule Votr.BallotLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "ballot_log" do
    # id is the ballot id
    # voter_id is an optional link to voter only when the ballot is mutable
    field(:voter_id, :integer)
    field(:value, :string)
    timestamps()
  end

  @doc false
  def changeset(ballot_log, attrs) do
    ballot_log
    |> cast(attrs, [])
    |> validate_required([])
  end
end
