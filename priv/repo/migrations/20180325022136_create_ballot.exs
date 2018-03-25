defmodule Votr.Repo.Migrations.CreateBallot do
  use Ecto.Migration

  def change do
    create table(:ballot, comment: "An empty ballot") do
      add(:id, :bigint, :primary_key)
      add(:ward_id, :bigint, references(:ward, on_delete: :delete_all), null: true)
      add(:kind, :varchar, null: false, comment: "How votes are cast and counted (eg. ranked)")
      add(:elect, :smallint, null: false, default: 1)
      add(:shuffle, :char, size: 1, null: false, default: 'N')
      add(:mutable, :char, size: 1, null: false, default: 'N', comment: "Vote can be changed")
      timestamps()
    end
  end
end
