defmodule Votr.Api.AuthenticationTest do
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  import Ecto.Query

  alias Votr.Identity.Token
  alias Votr.Identity.Principal
  alias Votr.JWT
  alias Votr.HashId

  test "authenticate with a jwt token" do
    build_conn()
    |> put_req_header("content-type", "application/json")
    |> post("/api/subjects", %{username: "testy.testerton@example.com", password: "p@ssw0rd"})
    |> json_response(200)

    token = from(Token)
            |> where([usage: "account"])
            |> Votr.Repo.all()
            |> Enum.at(0)

    build_conn()
    |> post("/api/activate", %{code: HashId.encode(token.id) })
    |> json_response(200)

    password = from(Principal)
            |> where([kind: "password"])
            |> Votr.Repo.all()
            |> Enum.at(0)

    jwt = JWT.generate(password.subject_id)

    # unauthenticated request
    build_conn()
    |> get("/api/admin/wards/root/wards")
    |> json_response(401)

    # authenticated request
    build_conn()
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> get("/api/admin/wards/root/wards")
    |> json_response(200)

  end
end
