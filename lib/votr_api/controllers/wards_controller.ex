defmodule Votr.Api.WardsController do
  use VotrWeb, :controller
  use Timex
  alias Votr.Election.Ward

  def index(conn, _params) do
    subject_id = conn.assigns[:subject_id]

    wards = Ward.select_for_subject(subject_id)
    conn
    |> put_status(200)
    |> json(%{success: true, wards: wards})
  end

  # create a new election or ward
  def create(
        conn,
        %{
          "parent_id" => parent_id,
          "ext_id" => ext_id,
          "name" => name,
          "start_time" => start_time,
          "end_time" => end_time
        }
      ) do

    subject_id = conn.assigns[:subject_id]

    case Ward.insert(subject_id, parent_id, ext_id, name, start_time, end_time) do
      {:ok, ward} ->
        conn
        |> put_status(201)
        |> json(
             %{
               success: true,
               ward: ward
             }
           )
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
