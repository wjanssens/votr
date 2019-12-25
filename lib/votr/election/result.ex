defmodule Votr.Election.Result do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Votr.Election.Result

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "result" do
    belongs_to :ballot, Ballot
    field :candidate_id, :integer
    field :version, :integer
    field :round, :integer     # ballots are evaluated in rounds
    field :status, :string     # in each round a candidate is either elected or excluded or eligible
    field :votes, :decimal     # the number of votes obtained by the candidate in this round
    field :received, :decimal  # the number of votes transferred to this candidate in this round
    field :surplus, :decimal   # the number of votes being transferred from this candidate in this round (votes - quota)
    field :exhausted, :decimal # the number of votes that couldn't be transferred from this candidate in this round
    has_one :candidate, Candidate, references: :candidate_id, on_delete: :delete_all
    timestamps()
  end

  def insert(result) do
    shard = FlexId.extract_partition(:id_generator, result.ballot_id)

    %Result{id: FlexId.generate(:id_generator, shard), version: 0}
    |> cast(result, [:ballot_id, :candidate_id, :round, :status, :votes, :surplus, :received, :exhausted])
    |> validate_required([:id, :version, :votes])
    |> Repo.insert()
  end

  def delete_all(subject_id, ballot_id) do
    Repo.delete_all from r in Result,
                    inner_join: b in assoc(r, :ballot),
                    inner_join: w in assoc(b, :ward),
                    where: w.subject_id == ^subject_id and r.ballot_id == ^ballot_id
  end

  @doc """
    Gets all of the results for a ballot.
  """
  def select(subject_id, ballot_id, lang_tag) do
    filter = if subject_id == nil do
      # anyone selecting public results
      dynamic([b, r, s], b.public == true and r.ballot_id == ^ballot_id)
    else
      # admin selecting results for a ward that belongs to them
      dynamic([w, r, s], w.subject_id == ^subject_id and r.ballot_id == ^ballot_id)
    end

    rows = Repo.all from r in Result,
                    inner_join: b in assoc(r, :ballot),
                    inner_join: w in assoc(b, :ward),
                    inner_join: c in assoc(r, :candidate),
                    left_join: s in assoc(c, :strings),
                    preload: [
                      candidate: c,
                      strings: s
                    ],
                    where: ^filter,
                    where: s.tag == ^lang_tag or s.tag == 'default',
                    select: r

    rows
    |> Enum.map(
         fn row ->
           %{
             round: row.round,
             name: Enum.at(row.candidate.strings, 0),
             votes: row.votes,
             status: row.status,
             surplus: row.surplus,
             received: row.received
           }
         end
       )
    |> Enum.group_by(fn result -> result.round end)
    |> Enum.map(
         fn {k, v} ->
           %{
             round: k,
             quota: case Enum.find(v, fn c -> c.status == 'elected' end) do
               nil -> nil
               elected -> elected.votes
             end,
             candidates: v
                         |> Enum.map(fn c -> Map.drop(c, [:round, :quota]) end)
                         |> Enum.sort_by(fn c -> c.status end, &>=/2)
           }
         end
       )
    |> Enum.sort_by(fn r -> r.round end, &>=/2)
  end
end
