defmodule Votr.Repo.Migrations.CreateCandidate do
  use Ecto.Migration

  def change do
    create table(:candidate, comment: "A comment on a ballot") do
      add(:id, :bigint, :primary_key, comment: "Shared with res")
      add(:seq, :int, null: false, comment: "Permits candidates to be ordered")
      add(:ballot_id, :bigint, references(:ballot, on_delete: :delete_all), null: false)
      add(:ext_id, :varchar, null: true, comment: "External reference")
      add(:withdrawn, :char, size: 1, null: false, default: 'N')
      timestamps()
    end
  end
end
