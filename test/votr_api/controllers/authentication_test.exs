defmodule Votr.Api.AuthenticationTest do
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  import Ecto.Query

  alias Votr.Identity.Token
  alias Votr.Identity.Principal
  alias Votr.HashId
  alias Votr.JWT

  test "register a new user" do
    build_conn()
    |> put_req_header("content-type", "application/json")
    |> post("/api/subjects", %{username: "testy.testerton@example.com", password: "p@ssw0rd"})
    |> json_response(201)

    token = from(Principal)
            |> Votr.Repo.all()
            |> Enum.filter(fn p -> p.kind == "token" end)
            |> Enum.map(&Token.from_principal/1)
            |> Enum.at(0)

    jwt = JWT.generate(token.subject_id)

    # activate the subject
    build_conn()
    |> get("/api/activate/" <> HashId.encode(token.id))
    |> json_response(200)

    # unauthenticated request for an activated subject
    build_conn()
    |> get("/api/admin/wards")
    |> json_response(401)

    # authenticated request for an activated subject
    build_conn()
    |> put_req_header("authentication", "Bearer " <> jwt)
    |> get("/api/admin/wards")
    |> json_response(200)

  end
end
