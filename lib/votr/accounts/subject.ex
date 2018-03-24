defmodule Votr.Accounts.Subject do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subject" do
    field(:id, :integer)
    timestamps()
  end

  @doc false
  def changeset(subject, attrs) do
    subject
    |> cast(attrs, [])
    |> validate_required([])
  end
end
