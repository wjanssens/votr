defmodule Votr.Repo.Migrations.CreateBallot do
  use Ecto.Migration

  def change do
    create table(:ballot, comment: "An ballot definition") do
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:ward_id, references(:ward, on_delete: :delete_all), null: true)
      add(:seq, :int, null: false, default: 1)
      add(:ext_id, :varchar, null: true, comment: "External reference")
      add(:method, :varchar, null: false, comment: "How votes are counted (eg. scottish_stv, plurality)")
      add(:electing, :smallint, null: false, default: 1, "How many candidates are being elected")
      add(:shuffle, :char, size: 1, null: false, default: "N", comment: "Candidates are presented in random order")
      add(:mutable, :char, size: 1, null: false, default: "N", comment: "Vote can be changed")
      add(:public, :char, size: 1, null: false, default: "Y", comment: "Results are publicly available")
      add(:color, :char, size: 6, null: true, comment: "Background color for ballot card")
      timestamps()
    end
  end
end
