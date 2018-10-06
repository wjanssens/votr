defmodule Votr.Api.WardsControllerTest do
  require Votr.Api.Fixture
  import Votr.Api.Fixture
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  test "create a new ward" do
    with_subject fn (token) ->
      body =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authentication", "Bearer " <> token)
        |> post("/api/admin/wards", %{name: %{default: "test", fr: "test"}, description: %{default: ""}})
        |> json_response(201)

      assert body["success"] == true
      ward_id = body["ward"]["id"]

      body =
        build_conn()
        |> put_req_header("authentication", "Bearer " <> token)
        |> get("/api/admin/wards")
        |> json_response(200)

      assert body["success"] == true
      wards = body["wards"]
      assert Enum.count(wards) == 1
      ward = Enum.at(wards, 0)
      assert ward["id"] == ward_id
      IO.inspect(ward)
#      assert ward["name"] == "test"
      assert ward["parent_id"] == nil
    end
  end
end
