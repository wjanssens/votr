defmodule Votr.Plurality do
  def eval(ballots, seats) do
    ballots
    |> Enum.reduce(
         %{},
         fn ballot, acc -> Enum.each(ballot, fn {c, _} -> Map.update(acc, c, 1, &(&1 + 1)) end) end
       )
    |> Enum.reduce(
         %{},
         fn {k, v}, acc -> Map.put(acc, k, %{votes: v}) end
       )
    |> evalp(seats)
  end

  defp evalp(result, seats) do
    IO.inspect(result)
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

        Map.put(result, elected_candidate, elected_result)
    end
  end

  @doc """
      Filters spoiled ballots for FPTP method
      Ballots must have a vote for every seat
  """
  def spoil_plurality(ballots, seats) do
    ballots
    |> Stream.filter(fn b -> Enum.count(b) == seats end)
  end

end
