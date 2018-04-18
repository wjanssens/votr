defmodule Votr.Identity.Principal do
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.Principal

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
  def changeset(attrs \\ %{}) do
    attrs = Map.update(attrs, :version, 0, &(&1 + 1))

    %Principal{}
    |> cast(attrs, [:id, :subject_id, :version, :kind, :seq, :hash, :value])
    |> validate_required([:id, :subject_id, :version, :kind, :value])
  end
end
