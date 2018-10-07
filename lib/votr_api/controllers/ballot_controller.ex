defmodule Votr.Api.BallotController do
  use VotrWeb, :controller
  alias Votr.Election.Ballot

  def index(conn, %{"id" => ward_id}) do
    subject_id = conn.assigns[:subject_id]
    ballots = Ballot.select_all(subject_id, ward_id)

    result = %{success: true, ballots: ballots}

    conn
    |> put_resp_content_type("application/json")
    |> put_status(:ok)
    |> json(result)
  end

end
