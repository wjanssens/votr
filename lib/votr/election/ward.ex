defmodule Votr.Election.Ward do
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Repo
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
  @derive {Poison.Encoder, only: [:id, :version, :subject_id, :parent_id, :seq, :ext_id, :name, :start_time, :end_time]}
  schema "ward" do
    field(:version, :integer)
    field(:subject_id, :integer)       # the owner / adminstrator for the election
    field(:parent_id, :integer)        # parent ward, null for elections
    field(:seq, :integer)              # the order in which wards are presented
    field(:ext_id, :string)            # reference to an external system
    field(:start_time, :utc_datetime)  # the date/time at which voting starts
    field(:end_time, :utc_datetime)    # the date/time at which voting ends
    field(:lat, :decimal)              # latitude
    field(:lon, :decimal)              # longitude
    timestamps()
  end

  def select_for_subject(subject_id) do
    results =
      """
      with recursive heirarchy (id, version, parent_id, seq, ext_id, start_time, end_time) as (
        select id, version, parent_id, seq, ext_id, start_time, end_time
        from ward w
        where parent_id is null and subject_id = $1
        union all
        select p.id, p.version, p.parent_id, p.seq, p.ext_id, p.start_time, p.end_time
        from ward p
        inner join heirarchy h on p.id = h.parent_id
      )
      select id, version, parent_id, seq, ext_id, start_time, end_time
      from heirarchy
      """
      |> Votr.Repo.query!([subject_id])

    results.rows
    |> Enum.map(&Repo.load(Ward, {results.columns, &1}))
  end

  def select_for_voter(voter_id) do
    # get all the wards a voter belongs to
    results =
      """
      with recursive heirarchy (id, parent_id, start_time, end_time) as (
        select id, parent_id, start_time, end_time
        from ward w
        inner join voter v on v.parent_id = w.id
        where v.id = $1
        union all
        select p.id, p.parent_id, p.start_time, p.end_time
        from ward p
        inner join heirarchy h on p.id = h.parent_id
      )
      select id, parent_id, max(start_time), min(end_time)
      from heirarchy
      """
      |> Votr.Repo.query!([voter_id])

    results.rows
    |> Enum.map(&Repo.load(Ward, {results.columns, &1}))
    |> Enum.group_by(&(&1.id), &(&1))
  end

  def insert(subject_id, parent_id, ext_id, start_time, end_time) do
    shard = FlexId.extract_partition(:id_generator, subject_id)
    id = FlexId.generate(:id_generator, shard)
    seq = 0 # TODO select a max+1 for this

    case %Ward{
           id: id,
           version: 0,
           subject_id: subject_id,
           parent_id: parent_id,
           seq: seq,
           ext_id: ext_id,
           start_time: start_time,
           end_time: end_time
         }
         |> cast(%{}, [:id, :version, :subject_id, :parent_id, :seq, :ext_id, :start_time, :end_time])
         |> validate_required([:id, :version, :subject_id, :seq])
         |> Repo.insert() do
      {:ok, ward} -> {:ok, ward}
      {:error, _} -> {:error, :constraint_violation}
    end
  end
end
