defmodule Votr.Repo.Migrations.CreateVoter do
  use Ecto.Migration

  def change do
    create table(:voter) do
      add(:id, :bigint, :primary_key)
      add(:ward_id, :bigint, references(:ward, on_delete: :delete_all), null: false)
      add(:ext_id, :varchar, null: true, comment: "External reference")
      add(:voted, :integer, null: false, default: 0)
      timestamps()
    end
  end
end
