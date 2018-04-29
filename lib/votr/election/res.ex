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
    field(:entity_id, :string)
    field(:tag, :string)
    field(:key, :string)
    field(:value, :string)
    timestamps()
  end

  def select(entity_ids) do
    Res
    |> where("entity_id" in ^entity_ids)
    |> order_by(:parent_id)
    |> Repo.all()
  end

  def insert(entity_id, tag, key, value) do
    shard = FlexId.extract_partition(:id_generator, entity_id)
    id = FlexId.generate(:id_generator, shard)

    case %Res{
           id: id,
           version: 0,
           entity_id: entity_id,
           tag: tag,
           key: key,
           value: AES.encrypt(value)
         }
         |> cast(%{}, [:id, :version, :entity_id, :tag, :key, :value])
         |> validate_required([:id, :version, :entity_id, :tag, :key, :value])
         |> Repo.insert() do
      {:ok, res} -> {:ok, res}
      {:error, _} -> {:error, :constraint_violation}
    end
  end
end
