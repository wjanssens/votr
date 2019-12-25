defmodule Votr.Api.BallotResultsController do
  use VotrWeb, :controller
  use Timex
  alias Votr.Election.Result
  alias Votr.HashId
  require Logger

  def index(conn, %{"ballot_id" => ballot_id}) do
    subject_id = conn.assigns[:subject_id]
    tags = Accept.extract_accept_language(conn)

    # TODO use real data instead of mock data
#    rounds = Result.select(subject_id, HashId.decode(ballot_id), Enum.at(tags, 0))

    rounds = [
               %{round: 5, quota: 26.0, name: "Monkey", votes: 26.0, status: "elected"},
               %{round: 5, quota: 26.0, name: "Gorilla", votes: 26.0, status: "elected"},
               %{round: 5, quota: 26.0, name: "Tarsier", votes: 0.0, status: "excluded"},
               %{round: 5, quota: 26.0, name: "Lynx", votes: 0, status: "excluded"},
               %{round: 5, quota: 26.0, name: "Tiger", votes: 26.0, status: "elected", surplus: 8.0},
               %{round: 5, quota: 26.0, name: "Exhausted", votes: 14.0, status: "exhausted", received: 8.0},

               %{round: 4, quota: 26.0, name: "Monkey", votes: 26.0, status: "elected"},
               %{round: 4, quota: 26.0, name: "Gorilla", votes: 26.0, status: "elected"},
               %{round: 4, quota: 26.0, name: "Tarsier", votes: 0.0, status: "excluded"},
               %{round: 4, quota: 26.0, name: "Lynx", votes: 0, status: "excluded", surplus: 13.0},
               %{round: 4, quota: 26.0, name: "Tiger", votes: 34.0, status: "eligible", received: 13.0},
               %{round: 4, quota: 26.0, name: "Exhausted", votes: 14.0, status: "exhausted"},

               %{round: 3, quota: 26.0, name: "Monkey", votes: 26.0, status: "elected"},
               %{round: 3, quota: 26.0, name: "Gorilla", votes: 26.0, status: "elected"},
               %{round: 3, quota: 26.0, name: "Tarsier", votes: 0, status: "excluded", surplus: 5.0},
               %{round: 3, quota: 26.0, name: "Lynx", votes: 13, status: "eligible"},
               %{round: 3, quota: 26.0, name: "Tiger", votes: 21, status: "eligible"},
               %{round: 3, quota: 26.0, name: "Exhausted", votes: 14.0, status: "exhausted", received: 5.0},

               %{round: 2, quota: 26.0, name: "Monkey", votes: 26.0, status: "elected"},
               %{round: 2, quota: 26.0, name: "Gorilla", votes: 26.0, status: "elected", surplus: 2.0},
               %{round: 2, quota: 26.0, name: "Tarsier", votes: 5, status: "eligible"},
               %{round: 2, quota: 26.0, name: "Lynx", votes: 13, status: "eligible"},
               %{round: 2, quota: 26.0, name: "Tiger", votes: 21, status: "eligible"},
               %{round: 2, quota: 26.0, name: "Exhausted", votes: 9.0, status: "exhausted", received: 2.0},

               %{round: 1, quota: 26.0, name: "Monkey", votes: 26.0, status: "elected", surplus: 7.0},
               %{round: 1, quota: 26.0, name: "Gorilla", votes: 28, status: "eligible"},
               %{round: 1, quota: 26.0, name: "Tarsier", votes: 5, status: "eligible"},
               %{round: 1, quota: 26.0, name: "Lynx", votes: 13, status: "eligible"},
               %{round: 1, quota: 26.0, name: "Tiger", votes: 21, status: "eligible"},
               %{round: 1, quota: 26.0, name: "Exhausted", votes: 7.0, status: "exhausted", received: 7.0},

               %{round: 0, quota: 26.0, name: "Monkey", votes: 33, status: "eligible"},
               %{round: 0, quota: 26.0, name: "Gorilla", votes: 28, status: "eligible"},
               %{round: 0, quota: 26.0, name: "Tarsier", votes: 5, status: "eligible"},
               %{round: 0, quota: 26.0, name: "Lynx", votes: 13, status: "eligible"},
               %{round: 0, quota: 26.0, name: "Tiger", votes: 21, status: "eligible"},
               %{round: 0, quota: 26.0, name: "Exhausted", votes: 0, status: "exhausted"}
             ]
             |> Enum.group_by(fn result -> result.round end)
             |> Enum.map(
                  fn {k, v} ->
                    %{
                      round: k,
                      quota: Enum.at(v, 0).quota,
                      candidates: v
                                  |> Enum.map(fn c -> Map.drop(c, [:round, :quota]) end)
                                  |> Enum.sort_by(fn c -> c.status end, &>=/2)
                    }
                  end
                )
             |> Enum.sort_by(fn r -> r.round end, &>=/2)

    conn
    |> put_status(200)
    |> json(%{success: true, data: rounds})
  end

end
