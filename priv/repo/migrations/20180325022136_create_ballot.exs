defmodule Votr.Repo.Migrations.CreateBallot do
  use Ecto.Migration

  def change do
    create table(:ballot, comment: "An ballot definition") do
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:ward_id, references(:ward, on_delete: :delete_all), null: true)
      add(:seq, :int, null: false, default: 1)
      add(:ext_id, :varchar, null: true, comment: "External reference")
      add(:kind, :varchar, null: false, comment: "How votes are cast and counted (eg. ranked)")
      add(:elect, :smallint, null: false, default: 1)
      add(:shuffle, :char, size: 1, null: false, default: "N")
      add(:mutable, :char, size: 1, null: false, default: "N", comment: "Vote can be changed")
      add(:color, :char, size: 6, null: true, comment: "Background color for ballot card")
      timestamps()
    end
  end
end
