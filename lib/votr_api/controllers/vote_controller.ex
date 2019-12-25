defmodule Votr.Api.VoteController do
  use VotrWeb, :controller
  alias Votr.Api.Accept
  alias Votr.Election.Ballot
  alias Votr.Repo

  def index(conn, body) do
    subject_id = conn.assigns[:subject_id]
    tags = Accept.extract_accept_language(conn)

    # gets all the ballots for the wards
    ballots = Ballot.select_for_voter(subject_id, Enum.at(tags, 0))

    conn
    |> put_resp_content_type("application/json")
    |> put_status(:ok)
    |> json(%{success: true, ballots: ballots})
  end

  def create(conn, %{votes: votes}) do
    subject_id = conn.assigns[:subject_id]

    all = votes
    |> Enum.map(fn {k, v} -> %{ballot_id: k, value: v} end)

    Repo.transaction(
      fn ->
        Vote.insert_all(subject_id, all)
        Voter.increment_voted_count(subject_id)
      end
    )

    conn
    |> put_resp_content_type("application/json")
    |> put_status(:ok)
    |> json(%{success: true})
  end

  defp translate(strings, tags, entity_id, key) do
    strings
    |> Enum.filter(&(&1.entity_id == entity_id))
    |> Enum.filter(&(&1.key == key))
    |> Enum.filter(&Enum.member?(tags, &1.tag))
    |> Enum.at(0)
    |> Enum.map(& &1.value)
  end

end
