defmodule Votr.Election.Ward do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Votr.Repo
  alias Votr.Election.Res
  alias Votr.Election.Voter
  alias Votr.Election.Ballot
  alias Votr.Election.Ward

  # wards are heirarchical
  # a federal election may have a national referendum, provincial MPs by ward
  # eg. referendum, calgary-centre
  # a municpal election may have a mayor, councilors by ward, school trustees by school board
  # eg. mayor, ward7, ward7-public

  # it can be useful to create wards with no ballots to create regions
  # with different polling times
  # eg. all Alberta wards should be have the same time

  @timestamps_opts [type: :utc_datetime, usec: true]
  @derive {
    Poison.Encoder,
    only: [
      :id,
      :version,
      :subject_id,
      :parent_id,
      :seq,
      :ext_id,
      :start_at,
      :end_at,
      :names,
      :descriptions,
      :ward_ct,
      :voter_ct,
      :ballot_ct,
      :updated_at
    ]
  }
  schema "ward" do
    field :version, :integer
    field :subject_id, :integer       # the owner / adminstrator for the election
    field :parent_id, :integer        # parent ward, null for elections
    field :seq, :integer              # the order in which wards are presented
    field :ext_id, :string            # reference to an external system
    field :start_at, :utc_datetime    # the date/time at which voting starts
    field :end_at, :utc_datetime      # the date/time at which voting ends
    field :ward_ct, :integer, virtual: true
    field :voter_ct, :integer, virtual: true
    field :ballot_ct, :integer, virtual: true
    has_many :strings, Res, foreign_key: :entity_id, on_delete: :delete_all
    has_many :ballots, Ballot, foreign_key: :ward_id, on_delete: :delete_all
    has_many :voters, Voter, foreign_key: :ward_id, on_delete: :delete_all
    has_many :wards, Ward, foreign_key: :parent_id, on_delete: :delete_all
    timestamps()
  end

  @doc """
    Gets all of the wards for a subject.
  """
  def select(subject_id, parent_id \\ nil) do
    filter = if parent_id == nil do
      dynamic([w], w.subject_id == ^subject_id and is_nil(w.parent_id))
    else
      dynamic([w], w.subject_id == ^subject_id and w.parent_id == ^parent_id)
    end

    Repo.all from w in Ward,
             left_join: s in assoc(w, :strings),
             left_join: c in assoc(w, :wards),
             left_join: b in assoc(w, :ballots),
             left_join: v in assoc(w, :voters),
             preload: [
               strings: s
             ],
             where: ^filter,
             select: w,
             select_merge: %{
               ward_ct: count(c.id, :distinct),
               ballot_ct: count(b.id, :distinct),
               voter_ct: count(v.id, :distinct)
             },
             group_by: [w.id, s.id]
  end

  def insert(params) do
    shard = FlexId.extract_partition(:id_generator, params.subject_id)

    %Ward{id: FlexId.generate(:id_generator, shard), version: 0}
    |> cast(params, [:version, :subject_id, :parent_id, :seq, :ext_id, :start_at, :end_at])
    |> validate_required([:id, :version, :subject_id, :seq])
    |> Repo.insert()
  end

  def update(params) do
    try do
      reorder(params)

      %Ward{id: params.id}
      |> cast(params, [:version, :parent_id, :ext_id, :start_at, :end_at])
      |> validate_required([:id, :version, :seq])
      |> optimistic_lock(:version)
      |> Repo.update()
    rescue
      e in Ecto.StaleEntryError -> {:conflict, e.message}
    end
  end

  def delete(id) do
    Repo.delete(%Ward{id: id})
  end

  @doc """
    Re-sequences all wards that are at the same level as as the ward being updated.
  """
  def reorder(ward) do
    sql = """
    WITH row_to_move AS (
      SELECT parent_id, seq AS old_seq
      FROM ward
      WHERE id = $1
    ), rows_to_update AS (
      SELECT id, old_seq
      FROM ward
      CROSS JOIN row_to_move
      WHERE (ward.parent_id is not distinct from row_to_move.parent_id)
      AND seq BETWEEN
        CASE WHEN old_seq < $2 THEN old_seq ELSE $2 END AND
        CASE WHEN old_seq > $2 THEN old_seq ELSE $2 END
    )
    UPDATE ward
    SET seq = CASE
      WHEN ward.id = $1 THEN $2
      WHEN old_seq < $2 THEN seq - 1
      WHEN old_seq > $2 THEN seq + 1
    END
    FROM rows_to_update
    WHERE rows_to_update.id = ward.id
    """

    with {:ok, _} <- Ecto.Adapters.SQL.query(Repo, sql, [ward.id, ward.seq])
      do
    else {:error, msg} ->
      {:error, msg}
    end
  end

end
