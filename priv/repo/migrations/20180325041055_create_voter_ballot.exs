defmodule Votr.Repo.Migrations.CreateVoterBallot do
  use Ecto.Migration

  def change do
    create table(:voter_ballot, comment: "assignment of ballot to voter") do
      add(:id, :bigint, :primary_key)
      add(:voter_id, :bigint, references(:voter, on_delete: :delete_all), null: false)
      add(:ballot_id, :bigint, references(:ballot, on_delete: :delete_all), null: false)
      timestamps()
    end
  end
end
