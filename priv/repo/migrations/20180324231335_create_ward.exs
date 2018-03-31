defmodule Votr.Repo.Migrations.CreateElection do
  use Ecto.Migration

  def change do
    create table(:ward) do
      add(:id, :bigint, :primary_key, comment: "Shared with res")
      add(:subject_id, :bigint, null: true, comment: "Owner")
      add(:ward_id, :bigint, null: true, comment: "Parent ward")
      add(:ext_id, :varchar, null: true, comment: "External reference")
      add(:name, :varchar, null: false, comment: "Path segment name")
      add(:start_time, :timestamptz, null: false, comment: "When voting starts in this ward")
      add(:end_time, :timestamptz, null: false, comment: "When voting ends in this ward")
      timestamps()
    end
  end
end
