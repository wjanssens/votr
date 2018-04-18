defmodule Votr.Repo.Migrations.CreateResult do
  use Ecto.Migration

  def change do
    create table(:result, comment: "Calculated election results") do
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:ward_id, references(:ward, on_delete: :delete_all), null: false)
      add(:round, :int, null: false, comment: "The round of election or exclusion")
      add(:status, :char, size: 1, null: true, comment: "Elected or eXcluded")
      add(:votes, :decimal, precision: 11, scale: 5, comment: "Votes obtained")
      add(:surplus, :decimal, precision: 11, scale: 5, comment: "Votes transferred")
      add(:exhausted, :decimal, precision: 11, scale: 5, comment: "Untransferrable votes")
      timestamps()
    end
  end
end
