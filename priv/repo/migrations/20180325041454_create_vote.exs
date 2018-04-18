defmodule Votr.Repo.Migrations.CreateBallotLog do
  use Ecto.Migration

  def change do
    create table(:vote, comment: "A voters vote for a ballot") do
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:ballot_id, references(:ballot, on_delete: :delete_all), null: false)
      add(:voter_id, references(:voter, on_delete: :nilify_all), null: true)
      add(:value, :text, null: false, comment: "eg. '3 1=2 - 5 0'")
      timestamps()
    end
  end
end
