defmodule Votr.Repo.Migrations.CreateVoter do
  use Ecto.Migration

  def change do
    create table(:voter, comment: "A voter in a ward") do
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:ward_id, references(:ward, on_delete: :delete_all), null: false)
      add(:ext_id, :varchar, null: true, comment: "External reference")
      add(:voted, :integer, null: false, default: 0)
      timestamps()
    end
  end
end
