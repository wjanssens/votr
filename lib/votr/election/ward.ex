defmodule Votr.Election.Ward do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Votr.Repo
  alias Votr.Election.Res
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
    only: [:id, :version, :subject_id, :parent_id, :seq, :ext_id, :name, :start_time, :end_time, :name, :description]
  }
  schema "ward" do
    field :version, :integer
    field :subject_id, :integer       # the owner / adminstrator for the election
    field :parent_id, :integer        # parent ward, null for elections
    field :seq, :integer              # the order in which wards are presented
    field :ext_id, :string            # reference to an external system
    field :start_time, :utc_datetime  # the date/time at which voting starts
    field :end_time, :utc_datetime    # the date/time at which voting ends
    has_many :strings, Res, foreign_key: :entity_id, on_delete: :delete_all
    timestamps()
  end

  @doc """
    Gets all of the wards for a subject.
  """
  def select_all(subject_id) do
    Repo.all from w in Ward,
             join: s in assoc(w, :strings),
             preload: [
               strings: s
             ],
             where: w.subject_id == ^subject_id,
             select: w
  end

  def insert(ward) do
    ward
    |> cast(%{}, [:id, :version, :subject_id, :parent_id, :seq, :ext_id, :start_time, :end_time])
    |> validate_required([:id, :version, :subject_id, :seq])
    |> Repo.insert()
  end

  def update(ward) do
    ward
    |> cast(%{}, [:id, :version, :subject_id, :parent_id, :seq, :ext_id, :start_time, :end_time])
    |> validate_required([:id, :version, :subject_id, :seq])
    |> optimistic_lock(:version)
    |> Repo.update()
  end

end
