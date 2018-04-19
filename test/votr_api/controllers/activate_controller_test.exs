defmodule Votr.Api.ActivateControllerTest do
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  @opts VotrWeb.Router.init([])

  describe "create/2" do
    test "register and activate a new user" do
      body =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/subjects", %{username: "testy.testerton@example.com", password: "p@ssw0rd"})
        |> json_response(201)

      token = "TODO need a mock email server"
      body =
        build_conn()
        |> get("/api/activate/" <> token)
        |> json_response(200)
    end
  end
end
