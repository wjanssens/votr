defmodule Votr.Identity.Principal do
  use Ecto.Schema
  import Ecto.Changeset

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
    :crypto.hash(:sha256, attrs.address)
    |> Base.encode64
  end

  def select(id, map \\ &(&1)) do
    case Repo.get(Principal, id)
      do
      nil -> {:error, :not_found}
      p -> {:ok, map(p)}
    end
  end

  def select_by_hash(hash, map, filter) do
    case from(Principal)
         |> where(hash: ^hash)
         |> Repo.all
         |> Enum.map(map(&1))
         |> Enum.filter(filter(&1))
         |> Enum.at(0, nil)
      do
      nil -> {:error, :not_found}
      p -> {:ok, p}
    end

    def insert(%Principal{} = principal, map \\ &(&1)) do
      insert(principal.subject_id, principal.kind, principal.seq, principal.value, principal.hash, map) do
    end

    def insert(subject_id, kind, seq, value, hash, map \\ &(&1)) do
      shard = FlexId.extract_partition(:id_generator, subject_id)
      id = FlexId.generate(:id_generator, shard)

      cond %Principal{
             id: id,
             subject_id: subject_id,
             version: 0,
             kind: kind,
             seq: seq,
             value: value,
             hash: hash
           }
           |> cast(attrs, [:id, :subject_id, :version, :kind, :seq, :value, :hash])
           |> validate_required([:id, :subject_id, :version, :kind, :value])
           |> Repo.insert() do
        {:ok, p} -> {:ok, map(p)}
        {:error, _} -> {:error, :constraint_error}
      end
    end

    def update(%Principal{} = p) do
      update(p.id, p.subject_id, p.version, p.value, p.hash)
    end

    def update(id, subject_id, version, value, hash, map) do
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
                  updated_at: DateTime.utc_now()
                ]
              )
           |> update_all([], true)
        do
        {0, _} -> {:error, :not_found}
        {1, p} -> {:ok, p}
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

    @doc false
    def changeset(attrs \\ %{}) do
      attrs = Map.update(attrs, :version, 0, &(&1 + 1))

      %Principal{}
      |> cast(attrs, [:id, :subject_id, :version, :kind, :seq, :hash, :value])
      |> validate_required([:id, :subject_id, :version, :kind, :value])
    end
  end
end