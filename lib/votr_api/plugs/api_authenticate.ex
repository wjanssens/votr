defmodule Votr.Plug.ApiAuthenticate do
  import Plug.Conn

  alias Votr.JWT

  def init(default), do: default

  def call(conn, _) do
    conn =
      conn
      |> fetch_query_params()
      |> fetch_cookies()

    authorization = get_req_header(conn, "authentication")
    cookie = conn.params["auth_token"]

    jwt = cond do
      authorization != nil -> authorization
      cookie == nil -> cookie
      true -> nil
    end

    case JWT.verify(jwt) do
      {:error, :invalid} ->
        conn
        |> put_status(401)
        |> Phoenix.Controller.json(%{success: false, error: "unauthorized", message: "Invalid authentication token"})
        |> halt
      {:ok, subject_id} ->
        conn
        |> assign(:subject_id, subject_id)
    end
  end
end
