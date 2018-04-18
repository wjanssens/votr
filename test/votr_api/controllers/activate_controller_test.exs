defmodule Votr.Api.ActivateControllerTest do
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  @opts VotrWeb.Router.init([])

  describe "create/2" do
    test "register and activate a new user" do
      # register
      body =
        %{username: "testy.testerton@example.com", password: "p@ssw0rd"}
        |> Poison.encode!()

      conn =
        build_conn(:post, "/api/subjects", body)
        |> put_req_header("content-type", "application/json")
        |> VotrWeb.Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200

      token = "TODO need a mock email server"
      conn =
        build_conn(:get, "/api/activate/" <> token)
        |> VotrWeb.Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200
    end
  end
end
