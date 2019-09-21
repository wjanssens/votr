defmodule Votr.Api.CandidatesControllerTest do
  require Votr.Api.Fixture
  import Votr.Api.Fixture
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  test "ballot lifecycle" do
    with_subject fn (subject, jwt) ->
      with_ward subject.id, fn (ward) ->
        with_ballot subject.id, ward.id, fn(ballot) ->
          ballot_id = Votr.HashId.encode(ballot.id)

          # add a candidate
          body =
            build_conn()
            |> put_req_header("content-type", "application/json")
            |> put_req_header("authorization", "Bearer #{jwt}")
            |> post(
                 "/api/admin/candidates",
                 %{
                   ballot_id: ballot_id,
                   seq: 0,
                   names: %{
                     default: "name",
                     fr: "nom"
                   },
                   descriptions: %{
                     default: "description",
                     fr: "description"
                   },
                   ext_id: "abc",
                   withdrawn: false,
                   color: "996633"
                 }
               )
            |> json_response(201)

          assert body["success"] == true
          candidate_id = body["candidate"]["id"]
          version = body["candidate"]["version"]

          # get all candidates
          body =
            build_conn()
            |> put_req_header("authorization", "Bearer #{jwt}")
            |> get("/api/admin/ballots/#{ballot_id}/candidates")
            |> json_response(200)

          assert body["success"] == true
          candidates = body["candidates"]
          assert Enum.count(candidates) == 1

          candidate = Enum.at(candidates, 0)
          assert candidate["id"] == candidate_id
          assert candidate["ballot_id"] == ballot_id

          # update a candidate
          body =
            build_conn()
            |> put_req_header("authorization", "Bearer #{jwt}")
            |> put(
                 "/api/admin/candidates/#{candidate_id}",
                 %{
                   id: candidate_id,
                   version: version,
                   seq: 2
                 }
               )
            |> json_response(200)

          assert body["success"] == true

          # delete a candidate
          body =
            build_conn()
            |> put_req_header("authorization", "Bearer #{jwt}")
            |> delete("/api/admin/candidates/#{candidate_id}")
            |> json_response(200)

          assert body["success"] == true

        end
      end
    end
  end
end
