defmodule Votr.Repo.Migrations.CreateSubject do
  use Ecto.Migration

  def change do
    create table(:subject) do
      add(:id, :bigint, [:primary_key])
      # subjects have no data of their own
      # they just serve to aggregate principals
      timestamps()
    end
  end
end
