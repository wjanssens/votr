defmodule Votr.Api.BallotsControllerTest do
  require Votr.Api.Fixture
  import Votr.Api.Fixture
  use VotrWeb.ConnCase
  use ExUnit.Case, async: true

  test "ballot lifecycle" do
    with_subject fn (subject, jwt) ->
      with_ward subject.id, fn (ward) ->
        ward_id = Votr.HashId.encode(ward.id)

        # add a ballot

        body =
          build_conn()
          |> put_req_header("content-type", "application/json")
          |> put_req_header("authorization", "Bearer #{jwt}")
          |> post(
               "/api/admin/ballots",
               %{
                 ward_id: ward_id,
                 seq: 0,
                 titles: %{
                   default: "title",
                   fr: "title"
                 },
                 ext_id: "ABC",
                 method: "scottish_stv",
                 quota: "droop",
                 electing: 2,
                 shuffle: true,
                 mutable: true,
                 public: true,
                 anonymous: true,
                 color: "996633"
               }
             )
          |> json_response(201)

        assert body["success"] == true
        ballot_id = body["ballot"]["id"]
        version = body["ballot"]["version"]

        # get all ballots
        body =
          build_conn()
          |> put_req_header("authorization", "Bearer #{jwt}")
          |> get("/api/admin/wards/#{ward_id}/ballots")
          |> json_response(200)

        assert body["success"] == true
        ballots = body["ballots"]
        assert Enum.count(ballots) == 1

        ballot = Enum.at(ballots, 0)
        assert ballot["id"] == ballot_id
        assert ballot["ward_id"] == ward_id

        # update a ballot
        body =
          build_conn()
          |> put_req_header("authorization", "Bearer #{jwt}")
          |> put(
               "/api/admin/ballots/#{ballot_id}",
               %{
                 id: ballot_id,
                 version: version,
                 seq: 5
               }
             )
          |> json_response(200)

        assert body["success"] == true

      end
    end
  end
end
