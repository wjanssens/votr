defmodule Votr.Api.SubjectsControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  describe "create/2" do
    test "register and activate a new user", %{conn: conn} do
      # register
      body =
        %{username: "testy.testerton@example.com", password: "p@ssw0rd"}
        |> Poison.encode!()

      response =
        conn(:post, "/api/subjects", body)
        |> put_req_header("content-type", "application/json")
        |> send_request

      assert response.status == 200

      response =
        conn(:get, "/api/activate/" <> token)
        |> send_request

      assert response.status == 200
    end
  end
end
