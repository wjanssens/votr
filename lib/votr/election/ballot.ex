defmodule Votr.Election.Ballot do
  use Ecto.Schema
  import Ecto.Changeset
  require Ecto.Query

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "ballot" do
    field(:version, :integer)
    field(:ward_id, :integer)
    field(:seq, :integer)              # the order in which ballots are presented to the voter
    field(:ext_id, :string)            # reference to an external system
    field(:method, :string)            # the count method (eg. scottish_stv, approval, plurality)
    field(:quota, :string)             # the quota (eg. droop, hare)
    field(:electing, :integer)         # how many candidates are being elected
    field(:shuffle, :boolean)          # candidates are displayed to the voter in a random order
    field(:mutable, :boolean)          # voters can change their vote
    field(:public, :boolean)           # results are publicly available
    field(:color, :string)             # used to color ballots to help distinguish multiple ballots in a ward
    timestamps()
  end

  @doc false
  def changeset(ballot, attrs) do
    ballot
    |> cast(attrs, [])
    |> validate_required([])
#    |> validate_inclusion(:method, ["scottish_stv", "meek_stv", "plurality", "approval", "condorcet"])
#    |> validate_includion(:quota,  ["droop", "hare", "imperator", "hagenback-bischoff"])
  end

  def select(ids) do
    Ballot
    |> Ecto.Query.where("ward_id" in ^ids)
    |> Ecto.Query.order_by([:ward_id, :seq])
    |> Votr.Repo.all()
  end
end
