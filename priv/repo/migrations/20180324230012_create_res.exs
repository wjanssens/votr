defmodule Votr.Repo.Migrations.CreateRes do
  use Ecto.Migration

  def change do
    create table(:res, comment: "Localized, encrypted string values for entities") do
      add(:id, :bigint, :primary_key)
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:entity_id, :bigint)
      add(:tag, :varchar, comment: "Language and Country code (eg. en-CA)")
      add(:key, :string, null: false, comment: "Resource key (eg. name)")
      add(:value, :text, null: false, comment: "Localized string")
      timestamps()
    end

    create(index(:res, [:entity_id, :tag, :key], unique: true, name: "uk_res"))
  end
end
