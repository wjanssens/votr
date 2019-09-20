defmodule Votr.Election.Candidate do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Votr.Repo
  alias Votr.Election.Ballot
  alias Votr.Election.Candidate
  alias Votr.Election.Res

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  @derive {
    Poison.Encoder,
    only: [
      :id,
      :version,
      :ballot_id,
      :seq,
      :ext_id,
      :withdrawn,
      :color,
      :names,
      :descriptions,
      :updated_at
    ]
  }
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

  defp verify_ownership(subject_id, ballot_id) do
    query = from b in Ballot,
                 inner_join: w in assoc(b, :ward),
                 where: w.subject_id == ^subject_id and b.id == ^ballot_id
    with 1 <- Repo.aggregate query, :count, :id do
      {:ok}
    else _ -> {:error, :not_found}
    end
  end

  def insert(subject_id, candidate) do
    with {:ok} <- verify_ownership(subject_id, candidate.ballot_id) do
      shard = FlexId.extract_partition(:id_generator, candidate.ballot_id)

      %Candidate{id: FlexId.generate(:id_generator, shard), version: 0}
      |> cast(candidate, [:ballot_id, :version, :seq, :ext_id, :withdrawn, :color])
      |> validate_required([:id, :version, :seq])
      |> Repo.insert()
    end
  end

  def update(subject_id, candidate) do
    with {:ok} <- verify_ownership(subject_id, candidate.ballot_id) do
      try do
        reorder(candidate)

        %Candidate{id: candidate.id}
        |> cast(candidate, [:version, :seq, :ext_id, :withdrawn, :color])
        |> validate_required([:id, :version, :seq])
        |> optimistic_lock(:version)
        |> Repo.update()
      rescue
        e in Ecto.StaleEntryError -> {:conflict, e.message}
      end
    end
  end

  @doc """
    Gets all of the candidates for the ballot.
  """
  def select(subject_id, ballot_id) do
    Repo.all from c in Candidate,
             inner_join: b in assoc(c, :ballot),
             inner_join: w in assoc(b, :ward),
             left_join: s in assoc(c, :strings),
             preload: [
               strings: s
             ],
             where: w.subject_id == ^subject_id and c.ballot_id == ^ballot_id,
             select: c
  end

  def delete(subject_id, id) do
    with {1, _} <- Repo.delete_all from c in Candidate,
                                   inner_join: b in assoc(c, :ballot),
                                   inner_join: w in assoc(b, :ward),
                                   where: w.subject_id == ^subject_id and b.id == ^id do
      {:ok, 1}
    else _ -> {:error, :not_found}
    end
  end

  @doc """
    Re-sequences ballots in a ward.
  """
  def reorder(candidate) do
    sql = """
    WITH row_to_move AS (
      SELECT ballot_id, seq AS old_seq
      FROM candidate
      WHERE id = $1
    ), rows_to_update AS (
      SELECT id, old_seq
      FROM candidate
      CROSS JOIN row_to_move
      WHERE (candidate.ballot_id = row_to_move.ballot_id)
      AND seq BETWEEN
        CASE WHEN old_seq < $2 THEN old_seq ELSE $2 END AND
        CASE WHEN old_seq > $2 THEN old_seq ELSE $2 END
    )
    UPDATE candidate
    SET seq = CASE
      WHEN candidate.id = $1 THEN $2
      WHEN old_seq < $2 THEN seq - 1
      WHEN old_seq > $2 THEN seq + 1
    END
    FROM rows_to_update
    WHERE rows_to_update.id = candidate.id
    """

    with {:ok, _} <- Ecto.Adapters.SQL.query(Repo, sql, [candidate.id, candidate.seq])
      do
    else {:error, msg} ->
      {:error, msg}
    end
  end
end
