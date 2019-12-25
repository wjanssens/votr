# TODO implement Borda count method
# TODO implement Condorcet count method
# TODO implement Block Plurality (multiple seats, unranked votes)
# TODO implement dynamic vs static option
# TODO implement STV tie breaking options
# TODO implement dynamic threshold
# TODO implement fractional vote rounding precision options
# TODO implement overvote and undervote handling options and reporting
# TODO implement Meek STV
# TODO implement Baas STV

defmodule Votr.Approval do
  def approval(ballots, seats) do
    # create a unique list of candidates
#    candidates =
#      ballots
#      |> Stream.flat_map(fn b -> Map.keys(b) end)
#      |> Stream.uniq()

    # create a result that has an empty entry for every candidate
#    result =
#      candidates
#      |> Enum.reduce(%{}, fn c, acc -> Map.put(acc, c, %{votes: 0}) end)

    # count the number of votes for each candidate
    result =
      ballots
      |> Stream.flat_map(fn b -> Map.keys(b) end)
      |> Enum.reduce(%{}, fn c, a -> Map.update(a, c, 1, &(&1 + 1)) end)

    1..seats
    |> Enum.reduce(
         result,
         fn _, a ->
           {elected_candidate, elected_result} =
             a
             |> Stream.filter(fn {_, v} -> !Map.has_key?(v, :status) end)
             |> Enum.max_by(fn {_, v} -> v.votes end)

           elected_result =
             elected_result
             |> Map.put(:status, :elected)

           Map.put(a, elected_candidate, elected_result)
         end
       )
  end

end
