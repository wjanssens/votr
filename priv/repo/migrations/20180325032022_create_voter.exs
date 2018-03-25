defmodule Votr.Repo.Migrations.CreateVoter do
  use Ecto.Migration

  def change do
    create table(:voter) do
      add(:id, :bigint, :primary_key)
      add(:ward_id, :bigint, references(:ward, on_delete: :delete_all), null: false)
      timestamps()
    end
  end
end
