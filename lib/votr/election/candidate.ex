defmodule Votr.Election.Candidate do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Votr.Election.Ballot
  alias Votr.Election.Candidate
  alias Votr.Election.Res

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "candidate" do
    belongs_to :ballot, Ballot
    field :version, :integer
    field :seq, :integer        # the order in which candidates appear on the ballot
    field :ext_id, :string      # reference to an external system
    field :withdrawn, :boolean  # this candidate has withdrawn
    field :color, :string       # the color to use in the result charts (not on the ballot)
    has_many :strings, Res, foreign_key: :entity_id, on_delete: :delete_all
    timestamps()
  end

  def upsert(ballot_id, candidate) do
    shard = FlexId.extract_partition(:id_generator, ballot_id)

    candidate
    |> Map.put_new_lazy(:id, fn -> FlexId.generate(:id_generator, shard)  end)
    |> cast(%{}, [:id, :ward_id, :version, :seq, :ext_id, :withdrawn, :color])
    |> validate_required([:seq])
    |> optimistic_lock(:version)
    |> Votr.Repo.insert
  end

  @doc """
    Gets all of the candidates for a ballot.
  """
  def select_all(subject_id, ballot_id) do
    Votr.Repo.all from c in Candidate,
                  join: b in assoc(c, :ballot),
                  join: w in assoc(b, :ward),
                  join: s in assoc(c, :strings),
                  preload: [
                    strings: s
                  ],
                  where: c.ballot_id == ^ballot_id and w.subject_id == ^subject_id,
                  select: c
  end

  @doc false
  def changeset(candidate, attrs) do
    candidate
    |> cast(attrs, [:ballot_id, :version, :ext_id, :withdrawn, :color])
    |> validate_required([:ballot_id, :version, :withdrawn])
  end
end
