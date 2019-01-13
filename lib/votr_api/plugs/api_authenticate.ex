defmodule Votr.Plug.ApiAuthenticate do
  import Plug.Conn

  alias Votr.JWT
  alias Votr.HashId

  def init(default), do: default

  def call(conn, _) do
    conn =
      conn
      |> fetch_query_params()
      |> fetch_cookies()

    authorization = Enum.at(get_req_header(conn, "authorization"), 0)
    cookie = conn.req_cookies["access_token"]

    jwt = cond do
      authorization != nil -> Enum.at(String.split(authorization, " ", parts: 2), 1)
      cookie != nil -> cookie
      true -> nil
    end

    with {:ok, sub} <- JWT.verify(jwt),
         subject_id <- HashId.decode(sub) do
      conn
      |> assign(:subject_id, subject_id)
    else
      _ ->
        conn
        |> put_status(401)
        |> Phoenix.Controller.json(%{success: false, error: "unauthorized"})
        |> halt
    end
  end
end
