defmodule Votr.Api.VotersController do
  use VotrWeb, :controller
  use Timex
  alias Votr.Election.Voter
  alias Votr.Identity.Subject
  alias Votr.Identity.Principal
  alias Votr.Identity.CommonName
  alias Votr.Identity.Phone
  alias Votr.Identity.Email
  alias Votr.Identity.PostalAddress
  alias Votr.Identity.Opaque
  alias Votr.HashId
  require Logger

  def index(conn, %{"ward_id" => ward_id}) do
    subject_id = conn.assigns[:subject_id]

    parent_id = HashId.decode(ward_id)
    nodes = Voter.select(subject_id, parent_id)

    voters = nodes
             |> Enum.map(
                  fn v ->
                    opaques = v.principals
                              |> Enum.filter(fn p -> p.kind == "opaque" end)
                              |> Enum.map(fn p -> Opaque.from_principal(p) end)
                              |> Enum.map(fn o -> o.hash end)

                    name = v.principals
                           |> Enum.filter(fn p -> p.kind == "common_name" end)
                           |> Enum.map(fn p -> CommonName.from_principal(p) end)
                           |> Enum.map(fn cn -> cn.name end)
                           |> Enum.at(0)

                    address = v.principals
                              |> Enum.filter(fn p -> p.kind == "postal_address" end)
                              |> Enum.map(fn p -> PostalAddress.from_principal(p) end)
                              |> Enum.map(fn a -> a.lines end)
                              |> Enum.at(0)

                    email = v.principals
                            |> Enum.filter(fn p -> p.kind == "email" end)
                            |> Enum.map(fn p -> Email.from_principal(p) end)
                            |> Enum.map(fn e -> e.address end)
                            |> Enum.at(0)

                    phone = v.principals
                            |> Enum.filter(fn p -> p.kind == "phone" end)
                            |> Enum.map(fn p -> Phone.from_principal(p) end)
                            |> Enum.map(fn p -> p.number end)
                            |> Enum.at(0)

                    v
                    |> Map.update(:id, nil, &(HashId.encode &1))
                    |> Map.update(:ward_id, nil, &(HashId.encode &1))
                    |> Map.update(:subject_id, nil, &(HashId.encode &1))
                    |> Map.put(:name, name)
                    |> Map.put(:address, address)
                    |> Map.put(:email, email)
                    |> Map.put(:phone, phone)
                    |> Map.put(:id1, Enum.find(opaques, fn o -> o.seq == 0 end))
                    |> Map.put(:id2, Enum.find(opaques, fn o -> o.seq == 1 end))
                    |> Map.drop([:principals])
                  end
                )

    conn
    |> put_status(:ok)
    |> json(%{success: true, voters: voters})
  end

  # create a voter
  def create(conn, body) do
    ward_id = HashId.decode(body["ward_id"])
    subject_id = conn.assigns[:subject_id]

    voter = %{
      ward_id: ward_id,
      ext_id: body["ext_id"]
    }

    with {:ok, subject} <- Subject.insert_voter(ward_id),
         {:ok, voter} <- Voter.insert(subject_id, Map.put_new(voter, :subject_id, subject.id)),
         {_, _} <- Principal.upsert_all(subject.id, principals(subject.id, body)) do
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
        |> json(%{success: false, error: "internal_server_error"})
    end
  end

  # update a voter
  def update(conn, body) do
    id = HashId.decode(body["id"])
    subject_id = conn.assigns[:subject_id]

    voter = %{
      id: id,
      version: body["version"],
      ext_id: body["ext_id"],
    }

    with {:ok, voter} <- Voter.update(subject_id, voter),
         {_, _} <- Principal.upsert_all(voter.id, principals(voter.subject_id, body)) do
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

  # delete a voter
  def delete(conn, body) do
    id = HashId.decode(body["id"])
    subject_id = conn.assigns[:subject_id]

    with {1, _} <- Voter.delete(subject_id, id) do
      conn
      |> put_status(:ok)
      |> json(
           %{
             success: true
           }
         )
    else
      _ ->
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

  defp principals(subject_id, body) do
    [
      if Map.has_key? body, :address do
        PostalAddress.to_principal(
          %{
            subject_id: subject_id,
            label: "home",
            failures: 0,
            lines: String.split(body["address"], "\n", trim: true)
          }
        )
      end,
      if Map.has_key? body, :name do
        CommonName.to_principal(
          %{
            subject_id: subject_id,
            name: body["name"]
          }
        )
      end,
      if Map.has_key? body, :email do
        Email.to_principal(
          %{
            subject_id: subject_id,
            label: "home",
            state: "valid",
            failures: 0,
            address: body["email"]
          }
        )
      end,
      if Map.has_key? body, :phone do
        Phone.to_principal(
          %{
            subject_id: subject_id,
            label: "phone",
            state: "valid",
            failures: 0,
            address: body["phone"]
          }
        )
      end,
      if Map.has_key? body, :id1 do
        Opaque.to_principal(
          %{
            subject_id: subject_id,
            seq: 0,
            hash: body["id1"]
          }
        )
      end,
      if Map.has_key? body, :id2 do
        Opaque.to_principal(
          %{
            subject_id: subject_id,
            seq: 1,
            hash: body["id2"]
          }
        )
      end
    ]
    |> Enum.filter(&is_map/1)
  end

end
