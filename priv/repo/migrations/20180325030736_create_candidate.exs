defmodule Votr.Repo.Migrations.CreateCandidate do
  use Ecto.Migration

  def change do
    create table(:candidate, comment: "A candidate on a ballot") do
      add(:version, :integer, null: false, default: 0, comment: "Optimistic concurrency version")
      add(:ballot_id, references(:ballot, on_delete: :delete_all), null: false)
      add(:seq, :int, null: false, comment: "Permits candidates to be ordered")
      add(:ext_id, :varchar, null: true, comment: "External reference")
      add(:withdrawn, :char, size: 1, null: false, default: "N")
      add(:color, :char, size: 6, null: true, comment: "Used in result charts")
      timestamps()
    end
  end
end
