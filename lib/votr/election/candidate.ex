defmodule Votr.Election.Candidate do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "candidate" do
    # res will join to this table using id to give candidate a localized name and description (party affiliation)
    # the seq is important even if candidates are shuffled for display on a ballot
    #   since the votes are recorded using the index of the candidate on the ballot
    #   and so the sequence cannot be changed once voting starts
    field(:version, :integer)
    field(:ballot_id, :integer)  # the ballot this candidate appears on
    field(:seq, :integer)        # the order in which candidates appear on the ballot
    field(:ext_id, :string)      # reference to an external system
    field(:withdrawn, :boolean)  # this candidate has withdrawn
    field(:color, :string)       # the color to use in the result charts (not on the ballot)
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
