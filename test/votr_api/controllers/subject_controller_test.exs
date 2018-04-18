defmodule Votr.Api.SubjectsControllerTest do
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
        |> VotrWeb.Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200
      assert conn.response_body == %{"status" => "success"}
    end
  end
end
