defmodule Votr.Repo.Migrations.CreateSubject do
  use Ecto.Migration

  def change do
    create table(:subject) do
      add(:id, :bigint, :primary_key)
      timestamps()
    end
  end
end
