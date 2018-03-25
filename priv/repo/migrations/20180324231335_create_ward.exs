defmodule Votr.Repo.Migrations.CreateElection do
  use Ecto.Migration

  def change do
    create table(:ward) do
      add(:id, :bigint, :primary_key, comment: "Shared with res")
      add(:subject_id, :bigint, null: true, comment: "Owner")
      add(:ward_id, :bigint, null: true, comment: "Parent ward")
      add(:name, :varchar, null: false, comment: "Path segment name")
      timestamps()
    end
  end
end
