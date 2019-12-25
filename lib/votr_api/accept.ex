defmodule Votr.Api.Accept do
  @moduledoc false

  def extract_accept_language(conn) do
    case conn
         |> Plug.Conn.get_req_header("accept-language") do
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
