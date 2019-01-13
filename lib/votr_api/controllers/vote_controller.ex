defmodule Votr.Api.VoteController do
  use VotrWeb, :controller
  alias Votr.Election.Ballot

  def index(conn, %{"id" => id}) do
    tags = extract_accept_language(conn)

    # gets all the ballots for the wards
    ballots = Ballot.select_for_voter(id, Enum.at(tags, 0))

    result = %{ success: true, ballots: ballots }

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
    |> Enum.concat("default")
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
