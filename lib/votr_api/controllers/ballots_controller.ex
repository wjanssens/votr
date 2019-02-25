defmodule Votr.Api.BallotsController do
  use VotrWeb, :controller
  use Timex
  alias Votr.AES
  alias Votr.Election.Ballot
  alias Votr.Election.Res
  alias Votr.HashId
  require Logger

  def index(conn, %{"ward_id" => ward_id}) do
    subject_id = conn.assigns[:subject_id]

    parent_id = HashId.decode(ward_id)
    nodes = Ballot.select(subject_id, parent_id)

    ballots = nodes
            |> Enum.map(
                 fn w ->
                   titles = w.strings
                           |> Enum.filter(fn res -> res.key == "title" end)
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
                   |> Map.update(:ward_id, nil, &(if is_nil(&1), do: nil, else: HashId.encode &1))
                   |> Map.update(:subject_id, nil, &(HashId.encode &1))
                   |> Map.put(:titles, titles)
                   |> Map.put(:descriptions, descs)
                   |> Map.drop([:strings])
                 end
               )

    conn
    |> put_status(200)
    |> json(%{success: true, ballots: ballots})
  end

  def create(conn, body) do
    ward_id = HashId.decode(body["ward_id"])

    # TODO verify that the subject owns the ward
    # any ballot inserted with an invalid ward id would be orphaned as it can't be selected

    ballot = %{
      ward_id: ward_id,
      seq: body["seq"] || 0,
      ext_id: body["ext_id"],
      method: body["method"],
      quota: body["quota"],
      electing: body["electing"],
      anonymous: body["anonymous"],
      shuffle: body["shuffle"],
      mutable: body["mutable"],
      public: body["public"],
      color: body["color"]
    }

    with {:ok, ballot} <- Ballot.insert(ballot),
         {_, _} <- Res.upsert_all(ballot.id, res(body, "titles", "title")),
         {_, _} <- Res.upsert_all(ballot.id, res(body, "descriptions", "description"))
      do
      conn
      |> put_status(:created)
      |> json(
           %{
             success: true,
             ballot: %{
               id: HashId.encode(ballot.id),
               version: ballot.version,
               updated_at: ballot.updated_at
             }
           }
         )
    else
      {:error, msg} ->
        Logger.warn "Failed to insert ballot: #{msg}"

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

  def update(conn, body) do
    id = HashId.decode(body["id"])

    ballot = %{
      id: id,
      version: body["version"],
      seq: body["seq"] || 0,
      ext_id: body["ext_id"],
      method: body["method"],
      quota: body["quota"],
      electing: body["electing"],
      anonymous: body["anonymous"],
      shuffle: body["shuffle"],
      mutable: body["mutable"],
      public: body["public"],
      color: body["color"]
    }

    with {:ok, ballot} <- Ballot.update(ballot),
         {_, _} <- Res.upsert_all(ballot.id, res(body, "titles", "title")),
         {_, _} <- Res.upsert_all(ballot.id, res(body, "descriptions", "description")) do
      conn
      |> put_status(:ok)
      |> json(
           %{
             success: true,
             ballot: %{
               id: HashId.encode(ballot.id),
               version: ballot.version,
               updated_at: ballot.updated_at
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
        Logger.warn "Failed to update ballot: #{msg}"

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
         {:ok, _} <- Ballot.delete(id) do
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

end
