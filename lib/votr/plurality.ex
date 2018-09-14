defmodule Votr.Plurality do
  def eval(ballots, seats \\ 1) do
    ballots
    |> Stream.filter(fn b -> Enum.count(b) <= seats end)
    |> Stream.flat_map(fn ballot -> Enum.reduce(ballot, [], fn {k, _}, acc -> [k | acc] end) end)
    |> Enum.reduce(%{}, fn c, acc -> Map.update(acc, c, %{votes: 1}, fn x -> Map.update!(x, :votes, &(&1 + 1)) end) end)
    |> evalp(seats)
  end

  defp evalp(result, seats) do
    cond do
      seats == 0 ->
        result
      true ->
        {elected_candidate, elected_result} = result
                                              |> Stream.filter(fn {_, v} -> !Map.has_key?(v, :status) end)
                                              |> Enum.max_by(fn {_, v} -> v.votes end)

        elected_result =
          elected_result
          |> Map.put(:status, :elected)

        result
        |> Map.put(elected_candidate, elected_result)
        |> evalp(seats - 1)
    end
  end
end
