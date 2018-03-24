defmodule Votr.Repo.Migrations.CreatePrincipal do
  use Ecto.Migration

  def change do
    create table(:principal) do
      add(:id, :bigint, :primary_key)
      add(:subject_id, references(:subject), null: false)
      add(:kind, :string, size: 8, null: false, comment: "Defines the type of principal")
      add(:seq, :integer, default: 0, comment: "Permits ordering")
      add(:hash, :string, comment: "Permits searching for encrypted data")
      add(:data, :text, null: false)
      timestamps()
    end
  end
end
