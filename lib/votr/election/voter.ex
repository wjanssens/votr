defmodule Votr.Election.Voter do
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Election.Res
  alias Votr.Election.Ward

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "voter" do
    belongs_to :ward, Ward
    field :version, :integer
    field :ext_id, :string   # reference to an external system
    field :voted, :integer   # indicates the number of times this voter voted
    has_many :strings, Res, foreign_key: :entity_id, on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(voter, attrs) do
    voter
    |> cast(attrs, [])
    |> validate_required([])
  end
end
