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

    authorization = Enum.at(get_req_header(conn, "authentication"), 0)
    cookie = conn.params["auth_token"]

    jwt = cond do
      authorization != nil -> Enum.at(String.split(authorization, " ", parts: 2), 1)
      cookie == nil -> cookie
      true -> nil
    end

    # TODO verify that the subject is authorized

    case JWT.verify(jwt) do
      {:error, :invalid} ->
        conn
        |> put_status(401)
        |> Phoenix.Controller.json(%{success: false, error: "unauthorized", message: "Invalid authentication token"})
        |> halt
      {:ok, subject_id} ->
        conn
        |> assign(:subject_id, HashId.decode(subject_id))
    end
  end
end
