defmodule Votr.Identity.Principal do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "principal" do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:kind, :string)
    field(:seq, :integer)
    field(:hash, :string)
    field(:value, :string)
    timestamps()
  end

  @doc false
  def changeset(principal, attrs) do
    principal
    |> cast(attrs, [])
    |> validate_required([])
  end
end
