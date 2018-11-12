defmodule Votr.Api.WardsController do
  use VotrWeb, :controller
  use Timex
  alias Votr.AES
  alias Votr.Election.Ward
  alias Votr.Election.Res
  alias Votr.HashId
  require Logger

  def index(conn, _params) do
    subject_id = conn.assigns[:subject_id]

    wards = Ward.select_all(subject_id)
            |> Enum.map(
                 fn w ->
                   names = w.strings
                           |> Enum.filter(fn res -> res.key == "name" end)
                           |> Enum.reduce(
                                %{},
                                fn res, acc -> Map.put(acc, res.tag, AES.decrypt(Base.decode64!(res.value))) end
                              )

                   descs = w.strings
                           |> Enum.filter(fn res -> res.key == "description" end)
                           |> Enum.reduce(
                                %{},
                                fn res, acc -> Map.put(acc, res.tag, AES.decrypt(Base.decode64!(res.value))) end
                              )

                   w
                   |> Map.update(:id, nil, &(HashId.encode &1))
                   |> Map.update(:parent_id, nil, &(if is_nil(&1), do: nil, else: HashId.encode &1))
                   |> Map.put(:name, names)
                   |> Map.put(:description, descs)
                   |> Map.drop([:strings])
                 end
               )
    conn
    |> put_status(200)
    |> json(%{success: true, wards: wards})
  end

  # create a new election or ward
  def create(conn, body) do
    subject_id = conn.assigns[:subject_id]
    shard = FlexId.extract_partition(:id_generator, subject_id)

    parent_id = if is_binary(body["parent_id"]), do: HashId.decode(body["parent_id"]), else: nil

    ward = %Ward{
      id: FlexId.generate(:id_generator, shard),
      version: 0,
      subject_id: subject_id,
      parent_id: parent_id,
      seq: body["seq"] || 0,
      ext_id: body["ext_id"],
      start_time: dt(body, "start_time"),
      end_time: dt(body, "end_time")
    }

    with {:ok, ward} <- Ward.insert(ward),
         {_, _} <- Res.upsert_all(ward.id, res(body, shard, "name")),
         {_, _} <- Res.upsert_all(ward.id, res(body, shard, "description"))
      do
      conn
      |> put_status(201)
      |> json(
           %{
             success: true,
             ward: %{
               id: HashId.encode(ward.id),
               version: ward.version
               # TODO include the other fields?
             }
           }
         )
    else
      {:error, msg} ->
        Logger.warn "Failed to insert ward: #{msg}"

        conn
        |> put_status(500)
        |> json(
             %{
               success: false,
               error: "server_error"
             }
           )
    end
  end

  # create a new election or ward
  def update(conn, body) do
    subject_id = conn.assigns[:subject_id]
    shard = FlexId.extract_partition(:id_generator, subject_id)

    parent_id = if is_binary(body["parent_id"]), do: HashId.decode(body["parent_id"]), else: nil

    ward = %Ward{
      id: HashId.decode(body["id"]),
      version: body["version"],
      subject_id: subject_id,
      parent_id: parent_id,
      seq: body["seq"] || 0,
      ext_id: body["ext_id"],
      start_time: dt(body, "start_time"),
      end_time: dt(body, "end_time")
    }

    with {:ok, ward} <- Ward.update(ward),
         {_, _} <- Res.upsert_all(ward.id, res(body, shard, "name")),
         {_, _} <- Res.upsert_all(ward.id, res(body, shard, "description")) do
      conn
      |> put_status(200)
      |> json(
           %{
             success: true,
             ward: %{
               id: HashId.encode(ward.id),
               version: ward.version
               # TODO include the other fields?
             }
           }
         )
    else
      {:error, msg} ->
        Logger.warn "Failed to update ward: #{msg}"

        conn
        |> put_status(500)
        |> json(
             %{
               success: false,
               error: "server_error"
             }
           )
    end
  end

  defp res(body, shard, key) do
    body[key]
    |> Enum.map(
         fn {k, v} -> %Res{
                        id: FlexId.generate(:id_generator, shard),
                        version: 0,
                        key: key,
                        tag: k,
                        value: v
                      }
         end
       )
  end

  defp dt(body, key) do
    with iso when is_binary(iso) <- Map.get(body, key),
         {:ok, dt} <- DateTime.from_iso8601(iso) do
      dt
    else
      _ -> nil
    end
  end
end
