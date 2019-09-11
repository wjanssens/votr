defmodule Votr.Repo.Migrations.CreateElection do
  use Ecto.Migration

  def change do
    create table(:ward, comment: "An election or ward within an election") do
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:subject_id, :bigint, null: true, comment: "Owner")
      add(:parent_id, :bigint, null: true, comment: "Parent ward, null for root ward/election")
      add(:ext_id, :varchar, null: true, comment: "External reference")
      add(:seq, :integer, null: false, comment: "Permits wards to be ordered")
      add(:type, :varchar, null: true, comment: "election, poll, or count")
      add(:start_at, :timestamptz, null: true, comment: "When voting starts in this ward")
      add(:end_at, :timestamptz, null: true, comment: "When voting ends in this ward")
      timestamps()
    end
  end
end
