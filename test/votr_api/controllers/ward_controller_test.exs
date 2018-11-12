defmodule Votr.Api.WardsControllerTest do
  require Votr.Api.Fixture
  import Votr.Api.Fixture
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  test "wards lifecycle" do
    with_subject fn (jwt) ->

      # add a ward
      body =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post(
             "/api/admin/wards",
             %{
               name: %{
                 default: "test",
                 fr: "test"
               },
               description: %{
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
               name: %{
                 default: "test",
                 fr: "test"
               },
               description: %{
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
        |> get("/api/admin/wards")
        |> json_response(200)

      assert body["success"] == true
      wards = body["wards"]
      assert Enum.count(wards) == 2

      assert Enum.at(wards, 0)["id"] == ward_id
      assert Enum.at(wards, 0)["parent_id"] == nil
      assert Enum.at(wards, 0)["name"]["default"] == "test"
      assert Enum.at(wards, 0)["name"]["fr"] == "test"
      assert Enum.at(wards, 0)["description"]["default"] == ""

      assert Enum.at(wards, 1)["parent_id"] == ward_id
      assert Enum.at(wards, 1)["name"]["default"] == "test"
      assert Enum.at(wards, 1)["name"]["fr"] == "test"
      assert Enum.at(wards, 1)["description"]["default"] == ""

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
               parent_id: ward_id,
               name: %{
                 default: "name",
                 fr: "nom"
               },
               description: %{
                 default: "description",
                 fr: "description"
               }
             }
           )
        |> json_response(200)

      assert body["success"] == true

    end
  end
end
