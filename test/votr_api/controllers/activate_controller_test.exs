defmodule Votr.Api.ActivateControllerTest do
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true
  import Ecto.Query
  alias Votr.Repo
  alias Votr.Identity.Principal
  alias Votr.Identity.Token

  describe "create/2" do
    test "register and activate a new user" do
      build_conn()
      |> put_req_header("content-type", "application/json")
      |> post("/api/subjects", %{username: "testy.testerton@example.com", password: "p@ssw0rd"})
      |> json_response(201)

      token = from(Principal)
      |> Repo.all()
      |> Enum.filter(fn p -> p.kind == "token" end)
      |> Enum.map(&Token.from_principal/1)
      |> Enum.at(0)

      build_conn()
      |> get("/api/activate/" <> HashId.encode(token.id))
      |> json_response(200)
    end
  end
end
