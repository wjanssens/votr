defmodule Votr.Election.Voter do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Votr.Repo
  alias Votr.Identity.Principal
  alias Votr.Identity.AccessCode
  alias Votr.Identity.IdentityCard
  alias Votr.Election.Res
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
      :access_code,
      :identity_card_1,
      :identity_card_2
    ]
  }
  schema "voter" do
    belongs_to :ward, Ward
    field :version, :integer
    field :ext_id, :string   # reference to an external system
    field :voted, :integer   # the number of times this voter voted
    field :weight, :float    # the weight that this voter's vote counts for
    has_many :strings, Res, foreign_key: :entity_id, on_delete: :delete_all
    has_many :principals, Principal, foreign_key: :subject_id, on_delete: :delete_all
    timestamps()
  end

  def insert(params) do
    shard = FlexId.extract_partition(:id_generator, params.ballot_id)

    %Voter{id: FlexId.generate(:id_generator, shard), version: 0}
    |> cast(
         params,
         [:ballot_id, :version, :ext_id, :weight, :voted]
       )
    |> validate_required([:id, :version])
    |> Repo.insert()
  end

  def update(params) do
    try do
      %Voter{id: params.id}
      |> cast(
           params,
           [:ballot_id, :version, :ext_id, :weight, :voted]
         )
      |> validate_required([:id, :version])
      |> optimistic_lock(:version)
      |> Repo.update()
    rescue
      e in Ecto.StaleEntryError -> {:conflict, e.message}
    end
  end

  @doc """
    Gets all of the voters for the ward.
  """
  def select(subject_id, ward_id) do
    Repo.all from v in Voter,
             inner_join: w in assoc(v, :ward),
             left_join: s in assoc(v, :strings),
             left_join: p in assoc(v, :principals),
             preload: [
               strings: s,
               principals: p
             ],
             where: w.subject_id == ^subject_id and v.ward_id == ^ward_id,
             select: v
  end

  def delete(id) do
    Repo.delete(%Voter{id: id})
  end
end
