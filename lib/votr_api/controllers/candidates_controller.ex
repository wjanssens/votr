defmodule Votr.Api.CandidatesController do
  use VotrWeb, :controller
  use Timex
  alias Votr.AES
  alias Votr.Election.Candidate
  alias Votr.Election.Res
  alias Votr.HashId
  require Logger

  def index(conn, %{"ballot_id" => ballot_id}) do
    subject_id = conn.assigns[:subject_id]

    parent_id = HashId.decode(ballot_id)
    nodes = Candidate.select(subject_id, parent_id)

    candidates = nodes
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
                   |> Map.update(:ballot_id, nil, &(if is_nil(&1), do: nil, else: HashId.encode &1))
                   |> Map.update(:subject_id, nil, &(HashId.encode &1))
                   |> Map.put(:names, names)
                   |> Map.put(:descriptions, descs)
                   |> Map.drop([:strings])
                 end
               )

    conn
    |> put_status(200)
    |> json(%{success: true, candidates: candidates})
  end

  def create(conn, body) do
    ballot_id = HashId.decode(body["ballot_id"])
    subject_id = conn.assigns[:subject_id]

    candidate = %{
      ballot_id: ballot_id,
      seq: body["seq"] || 0,
      ext_id: body["ext_id"],
      withdrawn: body["withdrawn"],
      color: body["color"]
    }

    with {:ok, candidate} <- Candidate.insert(subject_id, candidate),
         {_, _} <- Res.upsert_all(candidate.id, res(body, "names", "name")),
         {_, _} <- Res.upsert_all(candidate.id, res(body, "descriptions", "description"))
      do
      conn
      |> put_status(:created)
      |> json(
           %{
             success: true,
             candidate: %{
               id: HashId.encode(candidate.id),
               version: candidate.version,
               updated_at: candidate.updated_at
             }
           }
         )
    else
      {:error, msg} ->
        Logger.warn "Failed to insert candidate: #{msg}"

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
    subject_id = conn.assigns[:subject_id]

    candidate = %{
      id: id,
      version: body["version"],
      seq: body["seq"] || 0,
      ext_id: body["ext_id"],
      withdrawn: body["withdrawn"],
      color: body["color"]
    }

    with {:ok, candidate} <- Candidate.update(subject_id, candidate),
         {_, _} <- Res.upsert_all(candidate.id, res(body, "names", "name")),
         {_, _} <- Res.upsert_all(candidate.id, res(body, "descriptions", "description")) do
      conn
      |> put_status(:ok)
      |> json(
           %{
             success: true,
             candidate: %{
               id: HashId.encode(candidate.id),
               version: candidate.version,
               updated_at: candidate.updated_at
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
        Logger.warn "Failed to update candidate: #{msg}"

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
    subject_id = conn.assigns[:subject_id]

    with {:ok, _} <- Candidate.delete(subject_id, id) do
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
