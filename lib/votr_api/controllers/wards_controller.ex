defmodule Votr.Api.WardsController do
  use VotrWeb, :controller
  use Timex
  alias Votr.AES
  alias Votr.Election.Ward
  alias Votr.Election.Res

  # TODO use Timex to parse the date/times to deal with zones better; and deal with nulls better

  def index(conn, _params) do
    subject_id = conn.assigns[:subject_id]

    wards = Ward.select_all(subject_id)
            |> Enum.map(
                 fn w ->
                   names = w.strings
                           |> Enum.filter(fn res -> res.key == "name" end)
                           |> Enum.reduce(%{}, fn res, acc -> Map.put(acc, res.tag, AES.decrypt(Base.decode64!(res.value))) end)

                   descs = w.strings
                           |> Enum.filter(fn res -> res.key == "description" end)
                           |> Enum.reduce(%{}, fn res, acc -> Map.put(acc, res.tag, AES.decrypt(Base.decode64!(res.value))) end)

                   w
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

    names = body["name"]
            |> Enum.map(
                 fn {k, v} -> %Res{
                                id: FlexId.generate(:id_generator, shard),
                                version: 0,
                                key: "name",
                                tag: k,
                                value: v
                              }
                 end
               )
    descs = body["description"]
            |> Enum.map(
                 fn {k, v} -> %Res{
                                id: FlexId.generate(:id_generator, shard),
                                version: 0,
                                key: "description",
                                tag: k,
                                value: v
                              }
                 end
               )

    ward = %Ward{
      id: FlexId.generate(:id_generator, shard),
      version: 0,
      subject_id: subject_id,
      parent_id: body["parent_id"],
      seq: 0,
      ext_id: body["ext_id"],
      start_time: NaiveDateTime.from_iso8601!(body["start_time"]),
      end_time: NaiveDateTime.from_iso8601!(body["end_time"])
    }

    with {:ok, ward} <- Ward.upsert(ward),
         {_, _} <- Res.upsert_all(ward.id, names),
         {_, _} <- Res.upsert_all(ward.id, descs)
      do
      conn
      |> put_status(201)
      |> json(
           %{
             success: true,
             ward: %{
               id: ward.id
               # TODO include the other fields?
             }
           }
         )
    else
      {:error, msg} ->
        IO.inspect(msg)

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

    names = body.name
            |> Enum.map(fn {k, v} -> %{key: "name", tag: k, value: v} end)
    descriptions = body.desciption
                   |> Enum.map(fn {k, v} -> %{key: "description", tag: k, value: v} end)

    ward = %Ward{
      id: body["id"],
      version: body["version"],
      subject_id: subject_id,
      parent_id: body["parent_id"],
      seq: body["seq"],
      ext_id: body["ext_id"],
      start_time: NaiveDateTime.from_iso8601!(body["start_time"]),
      end_time: NaiveDateTime.from_iso8601!(body["end_time"])
    }

    with {:ok, ward} <- Ward.upsert(ward),
         {:ok, _} <- Res.upsert_all(ward.id, names),
         {:ok, _} <- Res.upsert_all(ward.id, descriptions)
      do
      conn
      |> put_status(200)
      |> json(
           %{
             success: true,
             ward: %{
               id: ward.id
               # TODO include the other fields?
             }
           }
         )
    else
      {:error, _} ->
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
end
