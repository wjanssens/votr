defmodule Votr.Api.ActivateControllerTest do
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true
  import Ecto.Query
  alias Votr.Repo
  alias Votr.Identity.Token
  alias Votr.HashId

  test "register and activate a new user" do
    build_conn()
    |> put_req_header("content-type", "application/json")
    |> post("/api/subjects", %{username: "testy.testerton@example.com", password: "p@ssw0rd"})
    |> json_response(200)

    token = from(Token)
            |> where([usage: "account"])
            |> Repo.all()
            |> Enum.at(0)

    build_conn()
    |> post("/api/activate", %{code: HashId.encode(token.id) })
    |> json_response(200)

    {:error, :not_found} = Token.select(token.id)
  end
end
