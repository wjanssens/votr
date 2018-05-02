defmodule Votr.Api.WardsControllerTest do
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  alias Votr.Identity.Subject
  alias Votr.Identity.Controls
  alias Votr.JWT

  test "create a new ward" do
    {:ok, subject} = Subject.insert("testy.testerton@example.com")
    {:ok, _} = Controls.insert(%Controls{subject_id: subject.id, failures: 0})
    token = JWT.generate(subject.id)

    body =
      build_conn()
      |> put_req_header("content-type", "application/json")
      |> put_req_header("authentication", "Bearer " <> token)
      |> post("/api/admin/wards", %{name: "test"})
      |> json_response(201)

    assert body["success"] == true
  end
end
