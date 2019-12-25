defmodule Votr.Repo.Migrations.CreateResult do
  use Ecto.Migration

  def change do
    create table(:result, comment: "Calculated election results") do
      add(:ballot_id, references(:ballot, on_delete: :delete_all), null: false)
      add(:candidate_id, references(:candidate, on_delete: :delete_all), null: false)
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:round, :int, null: false, comment: "The round of election or exclusion")
      add(:status, :varchar, size: 10, null: true, comment: "elected or eligible or excluded or exhausted")
      add(:votes, :decimal, precision: 11, scale: 5, comment: "votes obtained")
      add(:surplus, :decimal, precision: 11, scale: 5, comment: "Votes transferred from this candidate")
      add(:received, :decimal, precision: 11, scale: 5, comment: "votes transferred to this candidate")
      add(:exhausted, :decimal, precision: 11, scale: 5, comment: "votes that couldn't be transferred")
      timestamps()
    end
  end
end
