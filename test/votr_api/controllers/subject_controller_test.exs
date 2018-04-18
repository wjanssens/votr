defmodule Votr.Api.SubjectsControllerTest do
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  @opts VotrWeb.Router.init([])

  describe "create/2" do
    test "register a new user" do
      conn =
        build_conn(:post, "/api/subjects", %{username: "testy.testerton@example.com", password: "p@ssw0rd"})
        |> put_req_header("content-type", "application/json")
        |> VotrWeb.Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200
      assert conn.response_body == %{"status" => "success"}
    end
  end
end
