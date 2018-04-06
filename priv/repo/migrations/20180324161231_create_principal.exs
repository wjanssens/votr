defmodule Votr.Repo.Migrations.CreatePrincipal do
  use Ecto.Migration

  def change do
    create table(:principal) do
      add(:id, :bigint, :primary_key)
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:subject_id, references(:subject, on_delete: :delete_all), null: false)
      add(:kind, :varchar, null: false, comment: "Defines the type (eg. phone)")
      add(:seq, :integer, default: 0, comment: "Permits ordering (eg. primary email)")
      add(:hash, :varchar, comment: "Permits searching for encrypted data (eg. username)")
      add(:value, :text, null: false)
      timestamps()
    end
  end
end
