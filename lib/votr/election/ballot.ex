defmodule Votr.Election.Ballot do
  use Ecto.Schema
  import Ecto.Changeset
  require Ecto.Query

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "ballot" do
    field(:version, :integer)
    field(:ward_id, :integer)
    field(:seq, :integer)
    field(:res_id, :integer)
    field(:ext_id, :string)
    field(:kind, :string)
    field(:elect, :integer)
    field(:shuffle, :boolean)
    field(:mutable, :boolean)
    field(:color, :string)
    timestamps()
  end

  @doc false
  def changeset(ballot, attrs) do
    ballot
    |> cast(attrs, [])
    |> validate_required([])
    |> validate_inclusion(:kind, ["partially_ranked", "fully_ranked", "unranked", "approval"])
  end

  def select(ids) do
    Ballot
    |> Ecto.Query.where("ward_id" in ^ids)
    |> Ecto.Query.order_by([:ward_id, :seq])
    |> Votr.Repo.all()
  end
end
