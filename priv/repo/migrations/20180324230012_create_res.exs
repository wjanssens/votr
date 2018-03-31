defmodule Votr.Repo.Migrations.CreateRes do
  use Ecto.Migration

  def change do
    create table(:res, comment: "Localized, encrypted string values for entities") do
      add(:id, :bigint, :primary_key)
      add(:entity_id, :bigint)
      add(:tag, :varchar, comment: "Language and Country code (eg. en-CA)")
      add(:key, :string, null: false)
      add(:value, :text, null: false)
      timestamps()
    end

    create(index(:res, [:entity_id, :tag, :key], unique: true, name: "uk_res"))
  end
end
