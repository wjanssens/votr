defmodule Votr.Repo.Migrations.CreateElection do
  use Ecto.Migration

  def change do
    create table(:ward, comment: "An election or ward within an election") do
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:subject_id, :bigint, null: true, comment: "Owner")
      add(:ward_id, :bigint, null: true, comment: "Parent ward, null for root ward/election")
      add(:ext_id, :varchar, null: true, comment: "External reference")
      add(:seq, :integer, null: false, comment: "Permits wards to be ordered")
      add(:name, :varchar, null: false, comment: "Path segment name")
      add(:start_time, :timestamptz, null: true, comment: "When voting starts in this ward")
      add(:end_time, :timestamptz, null: true, comment: "When voting ends in this ward")
      timestamps()
    end
  end
end
