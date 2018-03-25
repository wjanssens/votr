defmodule Votr.VoterBallot do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "voter_ballot" do
    field(:voter_id, :integer)
    field(:ballot_id, :integer)
    timestamps()
  end

  @doc false
  def changeset(voter_ballot, attrs) do
    voter_ballot
    |> cast(attrs, [])
    |> validate_required([])
  end
end
