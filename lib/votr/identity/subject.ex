defmodule Votr.Identity.Subject do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "subject" do
    timestamps()
  end

  def insert(username) do
    shard = FlexId.make_partition(username)
    id = FlexId.generate(:id_generator, shard)

    %Subject{
      id: id
    }
    |> Repo.insert()
  end
end
