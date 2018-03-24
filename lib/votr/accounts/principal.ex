defmodule Votr.Principal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "principal" do
    field(:id, :integer)
    field(:subject_id, :integer)
    field(:kind, :string)
    field(:seq, :integer)
    field(:hash, :string)
    field(:data, :string)
    timestamps()
  end

  @doc false
  def changeset(principal, attrs) do
    principal
    |> cast(attrs, [])
    |> validate_required([])
  end
end
