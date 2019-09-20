defmodule Votr.Api.VotersControllerTest do
  require Votr.Api.Fixture
  import Votr.Api.Fixture
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  test "voter lifecycle" do
    with_subject fn (subject, jwt) ->
      with_ward subject.id, fn (ward) ->
        ward_id = Votr.HashId.encode(ward.id)

        # add a voter
        body =
          build_conn()
          |> put_req_header("content-type", "application/json")
          |> put_req_header("authorization", "Bearer #{jwt}")
          |> post(
               "/api/admin/voters",
               %{
                 ward_id: ward_id,
                 seq: 0,
                 ext_id: "abc",
                 weight: 1,
                 voted: 0,
                 name: "Name",
                 email: "email@example.com",
                 phone: "+1 403 555 1212",
                 id1: "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08",
                 id2: "60303ae22b998861bce3b28f33eec1be758a213c86c93c076dbe9f558c11c752"
               }
             )
          |> json_response(201)

        assert body["success"] == true
        voter_id = body["voter"]["id"]
        version = body["voter"]["version"]

        # get all voters
        body =
          build_conn()
          |> put_req_header("authorization", "Bearer #{jwt}")
          |> get("/api/admin/wards/#{ward_id}/voters")
          |> json_response(200)

        assert body["success"] == true
        voters = body["voters"]
        assert Enum.count(voters) == 1

        voter = Enum.at(voters, 0)
        assert voter["id"] == voter_id
        assert voter["ward_id"] == ward_id

        # update a voter
        body =
          build_conn()
          |> put_req_header("authorization", "Bearer #{jwt}")
          |> put(
               "/api/admin/voters/#{voter_id}",
               %{
                 id: voter_id,
                 version: version,
                 seq: 2
               }
             )
          |> json_response(200)

        assert body["success"] == true

        # delete a voter
        body =
          build_conn()
          |> put_req_header("authorization", "Bearer #{jwt}")
          |> delete("/api/admin/voters/#{voter_id}")
          |> json_response(200)

        assert body["success"] == true

      end
    end
  end
end
