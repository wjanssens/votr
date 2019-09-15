defmodule Votr.Api.WardsControllerTest do
  require Votr.Api.Fixture
  import Votr.Api.Fixture
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  test "wards lifecycle" do
    with_subject fn (_subject, jwt) ->

      # add a ward
      body =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post(
             "/api/admin/wards",
             %{
               seq: 0,
               names: %{
                 default: "test",
                 fr: "test"
               },
               descriptions: %{
                 default: ""
               }
             }
           )
        |> json_response(201)

      assert body["success"] == true
      ward_id = body["ward"]["id"]
      version = body["ward"]["version"]

      # add a ward
      body =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post(
             "/api/admin/wards",
             %{
               parent_id: ward_id,
               seq: 0,
               names: %{
                 default: "test",
                 fr: "test"
               },
               descriptions: %{
                 default: ""
               }
             }
           )
        |> json_response(201)

      assert body["success"] == true

      # get all wards
      body =
        build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get("/api/admin/wards/root/wards")
        |> json_response(200)

      assert body["success"] == true
      wards = body["wards"]
      assert Enum.count(wards) == 1

      ward = Enum.at(wards, 0)
      assert ward["id"] == ward_id
      assert ward["parent_id"] == nil
      assert ward["names"]["default"] == "test"
      assert ward["names"]["fr"] == "test"
      assert ward["descriptions"]["default"] == ""

      body =
        build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get("/api/admin/wards/#{ward_id}/wards")
        |> json_response(200)

      assert body["success"] == true
      wards = body["wards"]
      assert Enum.count(wards) == 1

      ward = Enum.at(wards, 0)
      assert ward["parent_id"] == ward_id
      assert ward["names"]["default"] == "test"
      assert ward["names"]["fr"] == "test"
      assert ward["descriptions"]["default"] == ""

      # update a ward
      body =
        build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put(
             "/api/admin/wards/#{ward_id}",
             %{
               id: ward_id,
               version: version,
               seq: 5,
               names: %{
                 default: "name",
                 fr: "nom"
               },
               descriptions: %{
                 default: "description",
                 fr: "description"
               }
             }
           )
        |> json_response(200)

      assert body["success"] == true

      # delete a ward
      body =
        build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> delete("/api/admin/wards/#{ward_id}")
        |> json_response(200)

      assert body["success"] == true

    end
  end
end
