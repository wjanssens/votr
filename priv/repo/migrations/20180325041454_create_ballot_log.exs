defmodule Votr.Repo.Migrations.CreateBallotLog do
  use Ecto.Migration

  def change do
    create table(:ballot_log) do
      add(:id, :bigint, :primary_key)
      add(:ballot_id, :bigint, references(:ballot, on_delete: :delete_all), null: false)
      add(:voter_id, :bigint, references(:voter, on_delete: :nilify_all), null: true)
      add(:value, :text, null: false, comment: "eg. '3 1=2 - 5 0'")
      timestamps()
    end
  end
end
