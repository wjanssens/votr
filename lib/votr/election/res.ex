defmodule Votr.Election.Res do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Votr.Repo
  alias Votr.AES
  alias Votr.Election.Res

  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "res" do
    field(:version, :integer)
    field(:entity_id, :integer)
    field(:tag, :string)        # the resource language (eg. fr)
    field(:key, :string)        # the resource key (eg. name)
    field(:value, :string)      # the resource value (eg. Libéral)
    timestamps()
  end

  def select(entity_ids) do
    Res
    |> where("entity_id" in ^entity_ids)
    |> Repo.all()
    |> Enum.map(fn p -> Map.update(p, :value, nil, Base.decode64(AES.decrypt(p.value))) end)
    |> Enum.group_by(&(&1.entity_id), &(&1))
  end

  @doc """
    Inserts or updates all resources for an entity
  """
  def upsert_all(entity_id, resources) do
    shard = FlexId.extract_partition(:id_generator, entity_id)

    resources
              |> Enum.map(
                   fn resource ->
                     resource
                     |> Map.put_new_lazy(:id, fn -> FlexId.generate(:id_generator, shard) end)
                     |> Map.put(:entity_id, entity_id)
                     |> Map.update(:value, nil, &(Base.encode64(AES.encrypt(&1))))
                     |> cast(%{}, [:id, :version, :entity_id, :tag, :key, :value])
                     |> validate_required([:id, :version, :entity_id, :tag, :key, :value])
                     |> optimistic_lock(:version)
                   end
                 )

    Repo.insert_all Res, entries
  end

  def delete_all(entity_id) do
    Repo.delete_all from r in Res,
                    where: r.entity_id == ^entity_id
  end

  def delete_all(entity_id, key) do
    Repo.delete_all from r in Res,
                    where: r.entity_id == ^entity_id and r.key == ^key
  end
end
