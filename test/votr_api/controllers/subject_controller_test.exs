defmodule Votr.Api.SubjectsControllerTest do
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  test "register a new user" do
    body =
      build_conn()
      |> put_req_header("content-type", "application/json")
      |> post("/api/subjects", %{username: "testy.testerton@example.com", password: "p@ssw0rd"})
      |> json_response(200)

    assert body == %{"success" => true}
  end

  test "detect duplicate registration" do
    body =
      build_conn()
      |> put_req_header("content-type", "application/json")
      |> post("/api/subjects", %{username: "testy.testerton@example.com", password: "p@ssw0rd"})
      |> json_response(200)

    assert body == %{"success" => true}

    build_conn()
      |> put_req_header("content-type", "application/json")
      |> post("/api/subjects", %{username: "testy.testerton@example.com", password: "p@ssw0rd"})
      |> json_response(200)
  end
end
