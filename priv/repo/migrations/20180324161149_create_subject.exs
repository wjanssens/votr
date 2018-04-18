defmodule Votr.Repo.Migrations.CreateSubject do
  use Ecto.Migration

  def change do
    create table(:subject, comment: "A grouping of related information for a single entity, such as a person") do
      # subjects have no data of their own
      # they just serve to aggregate principals
      timestamps()
    end
  end
end
