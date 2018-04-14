defmodule Votr.Election.Ward do
  use Ecto.Schema
  import Ecto.Changeset

  # wards are heirarchical
  # a federal election may have a national referendum, provincial MPs by ward
  # eg. referendum, calgary-centre
  # a municpal election may have a mayor, councilors by ward, school trustees by school board
  # eg. mayor, ward7, ward7-public

  # it can be useful to create wards with no ballots to create regions
  # with different polling times
  # eg. all Alberta wards should be have the same time

  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "ward" do
    # res will join to this table using id to give wards resource values
    field(:parent_id, :integer)
    field(:version, :integer)
    field(:res_id, :integer)
    field(:ext_id, :string)
    field(:name, :string)
    field(:start_time, :utc_datetime)
    field(:end_time, :utc_datetime)
    timestamps()
  end

  @doc false
  def changeset(election, attrs) do
    election
    |> cast(attrs, [])
    |> validate_required([])
  end

  def select_for_voter(voter_id) do
    # get all the wards a voter belongs to
    results =
      """
      with heirarchy (id, parent_id, res_id, start_time, end_time) as (
        select id, parent_id, res_id, start_time, duration
        from ward w
        inner join voter v on v.ward_id = w.id
        where v.id = $1
        union all
        select p.id, p.parent_id, p.res_id, p.start_time, p.duration
        from ward p
        inner join heirarchy h on p.id = h.parent_id
      )
      select id, parent, res_id, max(start_start), min(end_time)
      from heirarchy
      """
      |> Votr.Repo.query!([voter_id])

    results.rows
    |> Enum.map(&Ecto.Repo.load(Votr.Election.Ward, {results.columns, &1}))
    |> Enum.group_by(&(&1.id), &(&1))
  end
end
