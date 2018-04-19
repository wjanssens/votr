defmodule Votr.Api.SubjectsControllerTest do
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  @opts VotrWeb.Router.init([])

  describe "create/2" do
    test "register a new user" do
      body =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/subjects", %{username: "testy.testerton@example.com", password: "p@ssw0rd"})
        |> json_response(201)

      assert body == %{"success" => true}
    end
  end
end
