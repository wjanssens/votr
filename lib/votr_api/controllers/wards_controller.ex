defmodule Votr.Api.WardsController do
  use VotrWeb, :controller
  use Timex
  alias Votr.Election.Ward
  alias Votr.Election.Res

  def index(conn, _params) do
    subject_id = conn.assigns[:subject_id]

    wards = Ward.select_for_subject(subject_id)

    conn
    |> put_status(200)
    |> json(%{success: true, wards: wards})
  end

  # create a new election or ward
  def create(conn, body) do
    subject_id = conn.assigns[:subject_id]

    with {:ok, ward} <- Ward.insert(
      subject_id,
      body["parent_id"],
      body["ext_id"],
      body["start_time"],
      body["end_time"]
    ),
         {:ok, names} <- Res.insert_all(ward.id, "name", body["name"]),
         {:ok, descs} <- Res.insert_all(ward.id, "description", body["description"])
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
