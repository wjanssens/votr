defmodule Votr.Election.Voter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "voter" do
    # subject will join to this table using id to give voters secrets
    # the id will be printed on mailings so voters can fetch their ballots
    field(:ward_id, :integer)
    field(:voted, :integer)
    timestamps()
  end

  @doc false
  def changeset(voter, attrs) do
    voter
    |> cast(attrs, [])
    |> validate_required([])
  end
end
