defmodule Votr.Election.Voter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "voter" do
    # subject will join to this table using id to give voters secrets
    # the obfuscated id will be printed on mailings so voters can fetch their ballots
    field(:ward_id, :integer)
    field(:version, :integer)
    field(:ext_id, :string)   # reference to an external system
    field(:voted, :integer)   # indicates the number of times this voter voted
    timestamps()
  end

  @doc false
  def changeset(voter, attrs) do
    voter
    |> cast(attrs, [])
    |> validate_required([])
  end
end
