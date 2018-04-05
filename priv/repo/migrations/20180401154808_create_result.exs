defmodule Votr.Repo.Migrations.CreateResult do
  use Ecto.Migration

  def change do
    create table(:result) do
      add(:id, :bigint, :primary_key)
      add(:ward_id, :bigint, references(:ward, on_delete: :delete_all), null: false)
      add(:round, :int, null: false, comment: "The round of election or exclusion")
      add(:status, :char, size: 1, null: true, comment: "Elected or eXcluded")
      add(:votes, :decimal, precision: 11, scale: 5, comment: "Votes obtained")
      add(:surplus, :decimal, precision: 11, scale: 5, comment: "Votes transferred")
      add(:exhausted, :decimal, precision: 11, scale: 5, comment: "Untransferrable votes")
      timestamps()
    end
  end
end