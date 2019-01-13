defmodule Votr.Repo.Migrations.CreatePrincipal do
  use Ecto.Migration

  def change do
    create table(:token, comment: "Temporary tokens used for long running conversations") do
      add(:subject_id, references(:subject, on_delete: :delete_all), null: true)
      add(:usage, :varchar, null: false, comment: "eg. account, email, phone, password, totp")
      add(:value, :text, null: false, comment: "additional data needed to satisfy the request")
      add(:expires_at, :timestamptz, null: false, comment: "allows abandoned tokens to be removed")
      timestamps()
    end
  end
end
