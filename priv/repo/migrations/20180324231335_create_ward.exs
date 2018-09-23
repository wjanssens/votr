defmodule Votr.Repo.Migrations.CreateElection do
  use Ecto.Migration

  def change do
    create table(:ward, comment: "An election or ward within an election") do
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:subject_id, :bigint, null: true, comment: "Owner")
      add(:parent_id, :bigint, null: true, comment: "Parent ward, null for root ward/election")
      add(:ext_id, :varchar, null: true, comment: "External reference")
      add(:seq, :integer, null: false, comment: "Permits wards to be ordered")
      add(:start_time, :timestamptz, null: true, comment: "When voting starts in this ward")
      add(:end_time, :timestamptz, null: true, comment: "When voting ends in this ward")
      add(:lat, :decimal, scale: 10, precision: 6, null: true, comment: "Latitude")
      add(:lon, :decimal, scale: 10, precision: 6, null: true, comment: "Longitude")
      timestamps()
    end
  end
end
