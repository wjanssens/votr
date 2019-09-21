defmodule Votr.Election.Voter do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Votr.Repo
  alias Votr.Identity.Principal
  alias Votr.Election.Voter
  alias Votr.Election.Ward

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  @derive {
    Poison.Encoder,
    only: [
      :id,
      :version,
      :subject_id,
      :ward_id,
      :ext_id,
      :weight,
      :voted,
      :name,
      :email,
      :phone,
      :id1,
      :id2
    ]
  }
  schema "voter" do
    belongs_to :ward, Ward
    field :version, :integer
    field :ext_id, :string   # reference to an external system
    field :voted, :integer   # the number of times this voter voted
    field :weight, :decimal  # the weight that this voter's vote counts for
    has_one :subject, Subject, foreign_key: :subject_id, on_delete: :delete_all
    has_many :principals, Principal, foreign_key: :subject_id, on_delete: :delete_all
    timestamps()
  end

  def insert(subject_id, voter) do
    with {:ok} <- Ward.verify_ownership(subject_id, voter.ward_id) do
      shard = FlexId.extract_partition(:id_generator, voter.ward_id)

      %Voter{id: FlexId.generate(:id_generator, shard), version: 0}
      |> cast(voter, [:ward_id, :version, :ext_id, :weight, :voted])
      |> validate_required([:id, :version])
      |> Repo.insert()
    end
  end

  def verify_ownership(subject_id, voter_id) do
    query = from v in Voter,
                 inner_join: w in assoc(v, :ward),
                 where: w.subject_id == ^subject_id and v.id == ^voter_id
    with 1 <- Repo.aggregate query, :count, :id do
      {:ok}
    else _ -> {:error, :not_found}
    end
  end

  def update(subject_id, voter) do
    with {:ok} <- verify_ownership(subject_id, voter.id) do
      try do
        %Voter{id: voter.id}
        |> cast(voter, [:version, :ext_id, :weight, :voted])
        |> validate_required([:id, :version])
        |> optimistic_lock(:version)
        |> Repo.update()
      rescue
        e in Ecto.StaleEntryError -> {:conflict, e.message}
      end
    end
  end

  @doc """
    Gets all of the voters for the ward.
  """
  def select(subject_id, ward_id) do
    Repo.all from v in Voter,
             inner_join: w in assoc(v, :ward),
             left_join: p in assoc(v, :principals),
             preload: [
               principals: p
             ],
             where: w.subject_id == ^subject_id and v.ward_id == ^ward_id,
             select: v
  end

  def delete(subject_id, id) do
    # the associated subject and principals will cascade delete
    Repo.delete_all from v in Voter,
                    inner_join: w in assoc(v, :ward),
                    where: w.subject_id == ^subject_id and v.id == ^id
  end
end
