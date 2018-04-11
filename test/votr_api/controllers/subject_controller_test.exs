defmodule Votr.Api.SubjectsControllerTest do
  use Votr.Api.ConnCase
  use ExUnit.Case, async: true
  use Plug.Test

  alias Votr.Identity.Subject

  describe "create/2" do
    test "register and activate a new user", %{conn: conn} do
      # register
      body =
        %{username: "testy.testerton@example.com", password: "p@ssw0rd"}
        |> Poison.encode!()

      response =
        conn
        |> post(subjects_path(conn, :create))
        |> json_response(200)

      expected == %{"status" => "success"}
      assert response == expected
    end
  end
end
