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
    |> order_by(:parent_id)
    |> Repo.all()
    |> Enum.map(fn p -> Map.update(p, :value, nil, Base.decode64(AES.decrypt(p.value))) end)
    |> Enum.group_by(&(&1.entity_id), &(&1))
  end

  def insert(entity_id, key, tag, value) do
    shard = FlexId.extract_partition(:id_generator, entity_id)
    id = FlexId.generate(:id_generator, shard)

    case %Res{
           id: id,
           version: 0,
           entity_id: entity_id,
           key: key,
           tag: tag,
           value: Base.encode64(AES.encrypt(value))
         }
         |> cast(%{}, [:id, :version, :entity_id, :tag, :key, :value])
         |> validate_required([:id, :version, :entity_id, :tag, :key, :value])
         |> Repo.insert() do
      {:ok, res} -> {:ok, res}
      {:error, _} -> {:error, :constraint_violation}
    end
  end

  def insert_all(entity_id, key, pairs) do
    pairs
    |> Enum.reduce(
         {:ok, []},
         fn {tag, value}, {overall, list} ->
           case Res.insert(entity_id, key, tag, value) do
             {:ok, res} -> {overall, [res | list]}
             {:error, err} -> {:error, [err | list]}
           end
         end
       )
  end
end
