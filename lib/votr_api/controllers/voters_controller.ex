defmodule Votr.Api.VotersController do
  use VotrWeb, :controller
  use Timex
  alias Votr.AES
  alias Votr.Election.Voter
  alias Votr.Election.Res
  alias Votr.Identity.Principal
  alias Votr.Identity.AccessCode
  alias Votr.Identity.IdentityCard
  alias Votr.HashId
  require Logger

  def index(conn, %{"ward_id" => ward_id}) do
    subject_id = conn.assigns[:subject_id]

    parent_id = HashId.decode(ward_id)
    nodes = Voter.select(subject_id, parent_id)

    voters = nodes
             |> Enum.map(
                  fn v ->
                    names = v.strings
                            |> Enum.filter(fn res -> res.key == "name" end)
                            |> Enum.reduce(
                                 %{},
                                 fn res, acc -> Map.put(acc, res.tag, AES.decrypt(Base.decode64!(res.value))) end
                               )

                    access_code = v.principals
                                  |> Enum.filter(fn p -> p.kind == "access_code" end)
                                  |> Enum.map(fn p -> AccessCode.from_principal(p) end)
                                  |> Enum.map(fn ac -> ac.number end)
                                  |> Enum.at(0)

                    identity_cards = v.principals
                                     |> Enum.filter(fn p -> p.kind == "identity_card" end)
                                     |> Enum.map(fn p -> IdentityCard.from_principal(p) end)
                                     |> Enum.map(fn ic -> ic.value.number end)

                    v
                    |> Map.update(:id, nil, &(HashId.encode &1))
                    |> Map.update(:ward_id, nil, &(HashId.encode &1))
                    |> Map.update(:subject_id, nil, &(HashId.encode &1))
                    |> Map.put(:name, Map.get(names, "default"))
                    |> Map.drop([:strings])
                  end
                )

    conn
    |> put_status(:ok)
    |> json(%{success: true, voters: voters})
  end

  # create a new election or ward
  def create(conn, body) do
    ward_id = HashId.decode(body["ward_id"])

    voter = %{
      subject_id: conn.assigns[:subject_id],
      ward_id: ward_id,
      ext_id: body["ext_id"],
    }

    with {:ok, voter} <- Voter.insert(voter),
         {_, _} <- Res.upsert_all(voter.id, res(body)) do
      conn
      |> put_status(:created)
      |> json(
           %{
             success: true,
             voter: %{
               id: HashId.encode(voter.id),
               version: voter.version,
               updated_at: voter.updated_at
               # TODO include the other fields?
             }
           }
         )
    else
      {:error, msg} ->
        Logger.warn "Failed to insert voter: #{msg}"

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

    voter = %{
      id: id,
      version: body["version"],
      subject_id: subject_id,
      ext_id: body["ext_id"],
    }

    with {:ok, voter} <- Voter.update(voter),
         {_, _} <- Res.upsert_all(voter.id, res(body)) do
      conn
      |> put_status(:ok)
      |> json(
           %{
             success: true,
             voter: %{
               id: HashId.encode(voter.id),
               version: voter.version,
               updated_at: voter.updated_at
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
        Logger.warn "Failed to update voter: #{msg}"

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

    with {_, _} <- Principal.delete_all(id),
         {_, _} <- Res.delete_all(id),
         {:ok, _} <- Voter.delete(id) do
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

  defp res(body) do
    [
      %{
        key: "name",
        tag: "default",
        value: body["name"]
      }
    ]
  end

  defp principal(body, body_key, kind, seq) do
    value = body[body_key]
    %{
      key: "name",
      tag: "default",
      value: body["name"]
    }
  end
end
