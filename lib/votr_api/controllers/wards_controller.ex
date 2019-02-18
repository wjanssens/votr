defmodule Votr.Api.WardsController do
  use VotrWeb, :controller
  use Timex
  alias Votr.AES
  alias Votr.Election.Ward
  alias Votr.Election.Res
  alias Votr.HashId
  require Logger

  def index(conn, %{"ward_id" => ward_id}) do
    subject_id = conn.assigns[:subject_id]

    parent_id = if ward_id == "root", do: nil, else: HashId.decode(ward_id)
    nodes = Ward.select(subject_id, parent_id)

    wards = nodes
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
                   |> Map.update(:subject_id, nil, &(HashId.encode &1))
                   |> Map.put(:names, names)
                   |> Map.put(:descriptions, descs)
                   |> Map.drop([:strings])
                 end
               )

    conn
    |> put_status(:ok)
    |> json(%{success: true, wards: wards})
  end

  # create a new election or ward
  def create(conn, body) do
    parent_id = if is_binary(body["parent_id"]), do: HashId.decode(body["parent_id"]), else: nil

    ward = %{
      subject_id: conn.assigns[:subject_id],
      parent_id: parent_id,
      seq: body["seq"] || 0,
      ext_id: body["ext_id"],
      start_at: dt(body, "start_at"),
      end_at: dt(body, "end_at")
    }

    with {:ok, ward} <- Ward.insert(ward),
         {_, _} <- Res.upsert_all(ward.id, res(body, "names", "name")),
         {_, _} <- Res.upsert_all(ward.id, res(body, "descriptions", "description"))
      do
      conn
      |> put_status(:created)
      |> json(
           %{
             success: true,
             ward: %{
               id: HashId.encode(ward.id),
               version: ward.version,
               updated_at: ward.updated_at
               # TODO include the other fields?
             }
           }
         )
    else
      {:error, msg} ->
        Logger.warn "Failed to insert ward: #{msg}"

        conn
        |> put_status(:internal_server_error)
        |> json(
             %{
               success: false,
               error: "internal_server_error"
             }
           )
    end
  end

  # create a new election or ward
  def update(conn, body) do
    id = HashId.decode(body["id"])
    subject_id = conn.assigns[:subject_id]

    ward = %{
      id: id,
      version: body["version"],
      subject_id: subject_id,
      seq: body["seq"] || 0,
      ext_id: body["ext_id"],
      start_at: dt(body, "start_at"),
      end_at: dt(body, "end_at")
    }

    with {:ok, ward} <- Ward.update(ward),
         {_, _} <- Res.upsert_all(ward.id, res(body, "names", "name")),
         {_, _} <- Res.upsert_all(ward.id, res(body, "descriptions", "description")) do
      conn
      |> put_status(:ok)
      |> json(
           %{
             success: true,
             ward: %{
               id: HashId.encode(ward.id),
               version: ward.version,
               updated_at: ward.updated_at
               # TODO include the other fields?
             }
           }
         )
    else
      {:conflict, _msg} ->
        conn
        |> put_status(:conflict)
        |> json(
             %{
               success: false,
               error: "conflict"
             }
           )
      {:error, msg} ->
        Logger.warn "Failed to update ward: #{msg}"

        conn
        |> put_status(:internal_server_error)
        |> json(
             %{
               success: false,
               error: "internal_server_error"
             }
           )
    end
  end

  def delete(conn, body) do
    id = HashId.decode(body["id"])

    with {_, _} <- Res.delete_all(id),
         {_, _} <- Res.delete_all(id),
         {:ok, _} <- Ward.delete(id) do
      conn
      |> put_status(:ok)
      |> json(
           %{
             success: true
           }
         )
    else
      {:conflict, _msg} ->
        conn
        |> put_status(:conflict)
        |> json(
             %{
               success: false,
               error: "conflict"
             }
           )
    end
  end

  defp res(body, body_key, res_key) do
    value = body[body_key]
    (if is_nil(value), do: [], else: value)
    |> Enum.map(
         fn {k, v} -> %{
                        key: res_key,
                        tag: k,
                        value: v
                      }
         end
       )
  end

  defp dt(body, key) do
    with iso when is_binary(iso) <- Map.get(body, key),
         {:ok, dt, _offset} <- DateTime.from_iso8601(iso) do
      dt
    else
      _ -> nil
    end
  end
end
