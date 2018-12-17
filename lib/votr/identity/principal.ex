defmodule Votr.Identity.Principal do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Votr.Repo
  alias Votr.Identity.Principal


  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "principal" do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:kind, :string)
    field(:seq, :integer)
    field(:hash, :string)
    field(:value, :string)
    timestamps()
  end

  def hash(value) do
    :crypto.hash(:sha256, value)
    |> Base.encode64
  end

  def select(id, map \\ &(&1)) do
    case Repo.get(Principal, id)
      do
      nil -> {:error, :not_found}
      p -> {:ok, map.(p)}
    end
  end

  def select_by_subject_id(subject_id, kind, map \\ &(&1)) do
    from(Principal)
    |> where([subject_id: ^subject_id])
    |> where([kind: ^kind])
    |> Repo.all()
    |> Enum.map(map)
  end

  def select_by_hash(kind, hash, map, filter) do
    case from(Principal)
         |> where([hash: ^hash])
         |> where([kind: ^kind])
         |> Repo.all()
         |> Enum.map(map)
         |> Enum.filter(filter)
         |> Enum.at(0, nil)
      do
      nil -> {:error, :not_found}
      principal -> {:ok, principal}
    end
  end

  def insert(%Principal{} = principal, map \\ &(&1)) do
    insert(principal.subject_id, principal.kind, principal.seq, principal.value, principal.hash, map)
  end

  def insert(subject_id, kind, seq, value, hash, map \\ &(&1)) do
    shard = FlexId.extract_partition(:id_generator, subject_id)
    id = FlexId.generate(:id_generator, shard)

    case %Principal{
           id: id,
           subject_id: subject_id,
           version: 0,
           kind: kind,
           seq: seq,
           value: value,
           hash: hash
         }
         |> cast(%{}, [:id, :subject_id, :version, :kind, :seq, :value, :hash])
         |> validate_required([:id, :subject_id, :version, :kind, :value])
         |> Repo.insert() do
      {:ok, p} -> {:ok, map.(p)}
      {:error, _} -> {:error, :constraint_violation}
    end
  end

  def change(%Principal{} = p, map) do
    update(p.id, p.version, p.value, p.hash, map)
  end

  def update(id, version, value, hash, map) do
    case from(p in Principal)
         |> where([id: ^id])
         |> where([version: ^version])
         |> update(
              set: [
                value: ^value
              ]
            )
         |> update(
              set: [
                hash: ^hash
              ]
            )
         |> update(
              inc: [
                version: 1
              ]
            )
         |> update(
              set: [
                updated_at: fragment("current_timestamp")
              ]
            )
         |> Repo.update_all([], returning: true)
      do
      {0, _} -> {:error, :not_found}
      {1, p} -> {:ok, map.(Enum.at(p, 0))}
      {_, _} -> {:error, :too_many_affected}
    end
  end

  def delete(id, version) do
    case from(Principal)
         |> where([id: ^id])
         |> where([version: ^version])
         |> Repo.delete_all
      do
      {0, _} -> {:error, :not_found}
      {1, _} -> {:ok, nil}
      {_, _} -> {:error, :too_many_affected}
    end
  end

  def delete(id) do
    case from(Principal)
         |> where([id: ^id])
         |> Repo.delete_all
      do
      {0, _} -> {:error, :not_found}
      {1, _} -> {:ok, nil}
      {_, _} -> {:error, :too_many_affected}
    end
  end

end
