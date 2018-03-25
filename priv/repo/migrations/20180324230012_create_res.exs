defmodule Votr.Repo.Migrations.CreateRes do
  use Ecto.Migration

  def change do
    create table(:res, comment: "Localized, encrypted string values for entities") do
      add(:id, :bigint, comment: "Shared with ward, ballot, candidate, voter")
      add(:kind, :string, null: false, comment: "Defines the type (eg. name)")
      add(:lang, :varchar, comment: "Language and Country code (eg. en-CA)")
      add(:value, :text, null: false)
      timestamps()
    end

    create(index(:res, [:id, :kind, :lang], unique: true, name: "uk_res"))
  end
end
