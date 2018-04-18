defmodule Votr.Api.BallotController do
  use VotrWeb, :controller
  alias Votr.Election.Ward
  alias Votr.Election.Ballot
  alias Votr.Election.Candidate
  alias Votr.Election.Res

  def index(conn, %{"id" => id}) do
    tags = extract_accept_language(conn)

    # gets all the ballots for the wards
    wards = Ward.select_for_voter(id)
    ballots = Ballot.select(Map.keys(wards))

    candidates =
      Candidate.select(Enum.map(ballots, & &1.id))
      |> Enum.group_by(& &1.ballot_id, & &1)

    # get all the localized strings for all the ballots and candidates
    strings =
      Res.select(Enum.concat(ballots, Map.keys(candidates)))
      |> Enum.group_by(& &1.entity_id, & &1)

    result = %{
      success: true,
      ballots:
        Enum.map(ballots, fn b ->
          %{
            id: b.id,
            valid_interval: validity(wards[b.ward_id]),
            ward: translate(strings, b.ward_id, "name", tags),
            title: translate(strings, b.id, "title", tags),
            color: translate(strings, b.id, "color", tags),
            kind: b.kind,
            elect: b.elect,
            mutable: b.mutable,
            candidates:
              candidates[b.id]
              |> Enum.map(fn c ->
                %{
                  name: translate(strings, c.id, "name", tags),
                  affiliation: translate(strings, c.id, "affiliation", tags),
                  withdrawn: c.withdrawn
                }
              end)
          }
        end)
    }

    conn
    |> put_resp_content_type("application/json")
    |> put_status(:ok)
    |> json(result)
  end

  defp validity(ward) do
    "#{Date.to_iso8601(ward.start_time)}/#{ward.duration}"
  end

  defp translate(strings, tags, entity_id, key) do
    strings
    |> Enum.filter(&(&1.entity_id == entity_id))
    |> Enum.filter(&(&1.key == key))
    |> Enum.filter(&Enum.member?(tags, &1.tag))
    |> Enum.at(0)
    |> Enum.map(& &1.value)
  end

  defp extract_accept_language(conn) do
    case conn |> get_req_header("accept-language") do
      [value | _] ->
        value
        |> String.split(",")
        |> Enum.map(&parse_language_option/1)
        |> Enum.sort(&(&1.quality > &2.quality))
        |> Enum.map(& &1.tag)

      _ ->
        []
    end
    |> Enum.concat("*")
  end

  defp parse_language_option(string) do
    captures =
      ~r/^(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i
      |> Regex.named_captures(string)

    %{
      tag: captures["tag"],
      quality:
        case Float.parse(captures["quality"] || "1.0") do
          {val, _} -> val
          _ -> 1.0
        end
    }
  end
end
