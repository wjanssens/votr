defmodule Votr.Repo.Migrations.CreateBallot do
  use Ecto.Migration

  def change do
    create table(:ballot, comment: "An ballot definition") do
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:ward_id, references(:ward, on_delete: :delete_all), null: true)
      add(:seq, :int, null: false, default: 1)
      add(:ext_id, :varchar, null: true, comment: "External reference")
      add(:method, :varchar, null: false, comment: "How votes are counted (eg. scottish_stv, plurality)")
      add(:quota, :varchar, null: false, comment: "The quota (eg. droop, hare)")
      add(:electing, :smallint, null: false, default: 1, comment: "How many candidates are being elected")
      add(:shuffle, :bool, null: false, default: false, comment: "Candidates are presented in random order")
      add(:mutable, :bool, null: false, default: false, comment: "Vote can be changed")
      add(:public, :bool, null: false, default: true, comment: "Results are publicly available")
      add(:anonymous, :bool, null: false, default: true, comment: "Votes are anonymous")
      add(:color, :char, size: 6, null: true, comment: "Background color for ballot card")
      timestamps()
    end
  end
end
