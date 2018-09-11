# TODO implement Borda method
# TODO implement Condorcet method
# TODO implement Block Plurality (multiple seats, unranked votes)
# TODO implement dynamic vs static threshold option
# TODO implement STV tie breaking options (backwards, random)
# TODO implement fractional vote rounding precision options
# TODO implement overvote and undervote handling options and reporting
# TODO implement Meek STV
# TODO implement Baas STV

defmodule Votr.Stv do
  @moduledoc """
  Provides Ranked (STV, AV), and Unranked (FPTP) ballot evaluation.
  * STV uses a quota to determine when a candidate is elected in rounds.
  	Droop, Hare, Impirali, and Hagenbach Bischoff quotas are available.
  * IRV is a degenerate case of STV where only one seat is elected,
  	and all rounds are evaluated until the candidate with the majority is elected
  	or the last candidate standing with the most votes is elected.
  * FPTP is a degenerate case of AV where ballots have no rankings and thus
    no distribution can be performed.
  """

  @doc """
  Evaluates an election.
  * `ballots` a list of ballots;
  	with ranked votes for STV and AV, or unranked votes for FPTP.
  * `seats` the number of seats to elect; 1 for AV and FPTP, or > 1 for STV
  * Undervoting is handled by always choosing the candidate with least rank
  	(i.e. absolute rank isn't important, only relative rank is)
  * Overvoting is handled by choosing one of the candidates (in ballot order)
  	and deferring the other(s) into the next round

  ## Ballots
  Ballots are in the form of a list of maps where each map key is the
  candidate and each map value is the ranking.
  A ballot for FPTP should have only one key and a rank of 1.
  The key should may be either a string or a number.
  ```
  [
  	%{"a" => 1, "b" => 2, ...},
  	%{"c" => 1, "d" => 2, ...},
  	...
  ]
  ```

  ## Results
  Results are in the form of a map with an entry for each candidate.
  Each candidate is represented with a map of the following values:
  * `round` is the round that a candidate was :elected or :excluded in,
    or not present for candidates that weren't considered in any round
  * `votes` is the number of they obtained
    (which may not be an integer if there was fractional distrution)
  * `surplus` is the number of votes that they obtained beyond the quota which
    may be transferred to next choice candidates.  There will not be a surplus
  	for excluded candidates
  * `exhausted` is the number of votes that could not be transferred because
    there were no next choice candidates to choose from.
  * `status` is `:elected`, `:excluded`,
    or not present for candidates that weren't considered in any round
  ```
  %{
  	"a" => %{round: 1, status: :elected, votes: 40.0, surplus: 20.0, exhausted: 0},
  	"b" => %{round: 2, status: :excluded, votes: 8.0, exhausted: 0},
  	"c" => %{round: 3, status: :elected, votes: 20.0, surplus: 0.0, exhausted: 0},
  	"d" => %{votes: 17.0}
  }
  ```

  ## Options
      * `:quota` - the quota will be calculated according to
        `:imperali`, `:hare`, `:hagenbach_bischoff`, or `:droop` formulas; defaults to `:droop`
      * `:callback` - a function that will receive the intermediate results for each round
  """
  def eval(ballots, seats, options \\ []) do
    # find the unique list of candidates from all the ballots
    candidates =
      ballots
      |> Stream.flat_map(fn b -> Map.keys(b) end)
      |> Stream.uniq()

    # create a result that has an empty entry for every candidate
    result =
      candidates
      |> Enum.reduce(%{}, fn c, acc -> Map.put(acc, c, %{votes: 0}) end)

    # perform the initial vote distribution
    result = distribute(ranked_votes(ballots), result)
    # IO.inspect result

    quota =
      case seats do
        1 ->
          # make the quota a pure majority (equivalent to hagenbach_bischoff)
          Enum.count(ballots) / 2

        _ ->
          # calculate the number of votes it takes to be elected
          case Keyword.get(options, :quota, :droop) do
            :imperali -> Float.floor(Enum.count(ballots) / (seats + 2))
            :hare -> Float.floor(Enum.count(ballots) / seats)
            :hagenbach_bischoff -> Float.floor(Enum.count(ballots) / (seats + 1))
            _ -> Float.floor(Enum.count(ballots) / (seats + 1) + 1)
          end
      end

    eval(result, ballots, 1, 0, seats, quota, options)
  end

  # Recursively evaluate the subsequent rounds of the ranked election.
  # Returns updated results.
  defp eval(result, ballots, round, elected, seats, quota, options \\ []) do
    callback = Keyword.get(options, :callback)
    unless is_nil(callback) do callback.(round, result) end

    # IO.puts "round #{round}"
    # IO.inspect result
    cond do
      seats == elected ->
        result

      Enum.count(result, fn {_, v} -> !Map.has_key?(v, :status) end) == 1 ->
        # nobody has satisfied the quota and only one candidate standing
        # so they win by default even without satisfying the quota
        {elected_candidate, elected_result} =
          result
          |> Enum.find(fn {_, v} -> !Map.has_key?(v, :status) end)

        elected_result =
          elected_result
          |> Map.put(:surplus, elected_result.votes - quota)
          |> Map.put(:status, :elected)
          |> Map.put(:round, round)

        Map.put(result, elected_candidate, elected_result)

      true ->
        # IO.inspect result
        # find the candidate with the most votes
        {elected_candidate, elected_result} =
          result
          |> Stream.filter(fn {_, v} -> !Map.has_key?(v, :status) end)
          |> Enum.max_by(fn {_, v} -> v.votes end)

        if elected_result.votes >= quota do
          # candidate has enough votes to be elected
          # IO.puts "electing #{elected_candidate}"

          # determine how many votes need redistribution
          surplus = elected_result.votes - quota

          # update the result for the elected candidate
          elected_result =
            elected_result
            |> Map.put(:surplus, surplus)
            |> Map.put(:status, :elected)
            |> Map.put(:round, round)

          result = Map.put(result, elected_candidate, elected_result)

          # distribute all the second choice votes from the ballots that elected this candidate
          electing_ballots = used(ballots, elected_candidate)
          # IO.puts "weight =  #{surplus} / #{Enum.count(electing_ballots)}"
          # IO.inspect electing_ballots
          weight = surplus / Enum.count(electing_ballots)
          result = distribute(electing_ballots, result, elected_candidate, weight)

          # perform the next round using ballots that exclude the elected candidate
          next_ballots = filter_candidates(ballots, [elected_candidate])
          eval(result, next_ballots, round + 1, elected + 1, seats, quota, options)
        else
          # a candidate must be excluded
          # find the candidate with the least votes
          {excluded_candidate, excluded_result} =
            result
            |> Stream.filter(fn {_, v} -> !Map.has_key?(v, :status) end)
            |> Enum.min_by(fn {_, v} -> v.votes end)

          # IO.puts "excluding #{excluded_candidate}"

          # update the result for the excluded candidate
          excluded_result =
            excluded_result
            |> Map.put(:status, :excluded)
            |> Map.put(:round, round)

          result = Map.put(result, excluded_candidate, excluded_result)

          # distribute all the second choice votes from the ballots that excluded this candidate
          excluding_ballots = used(ballots, excluded_candidate)
          # IO.puts "weight =  #{excluded_result.votes} / #{Enum.count(excluding_ballots)}"
          # IO.inspect excluding_ballots
          weight = excluded_result.votes / Enum.count(excluding_ballots)
          result = distribute(excluding_ballots, result, excluded_candidate, weight)

          # perform the next round using ballots that exclude the elected candidate
          next_ballots = filter_candidates(ballots, [excluded_candidate])
          eval(result, next_ballots, round + 1, elected, seats, quota, options)
        end
    end
  end

  @doc """
  Returns a list of `ballots` that exclude all votes for `candidates`.
  This should be called to remove all withdrawn candidates prior to calling `eval/3`.
  """
  def filter_candidates(ballots, candidates) do
    ballots
    |> Stream.map(fn b -> Map.drop(b, candidates) end)
  end

  @doc """
  Filters spoiled ballots for FPTP method
  Ballots must have exactly one vote
  """
  def spoil_plurality(ballots) do
    ballots
    |> Stream.filter(fn b -> Enum.count(b) == 1 end)
  end

  @doc """
  Converts ranked ballots into unranked ballots.
  This is useful for conducting a simulated plurality election from ranked ballots.
  """
  def unranked(ballots) do
    ballots
    |> Stream.map(
         fn b ->
           {candidate, _} = Enum.min_by(b, fn {_, v} -> v end, {:nobody, 0})
           %{candidate => 1}
         end
       )
  end

  # Returns a list of ballots that contributed to a candidates election or exclusion
  defp used(ballots, candidate) do
    ballots
    |> Stream.filter(
         fn b ->
           b
           |> Enum.min_by(fn {_, v} -> v end, fn -> {:exhausted, 0} end)
           |> Tuple.to_list()
           |> Enum.member?(candidate)
         end
       )
  end

  # Returns a map of how many votes a candidates has obtained
  defp ranked_votes(ballots) do
    # count the number of votes for each candidate
    ballots
    |> Stream.map(
         fn b ->
           # vote(s) with the lowest rank
           # candidate from the vote
           b
           |> Enum.min_by(fn {_, v} -> v end, fn -> {:exhausted, 0} end)
           |> Tuple.to_list()
           |> List.first()
         end
       )
    |> Enum.reduce(%{}, fn c, a -> Map.update(a, c, 1, &(&1 + 1)) end)
  end

  # Applies initial vote distribution to result for all candidates.
  # Returns updated results.
  defp distribute(counts, result) do
    Enum.reduce(
      result,
      %{},
      fn {rk, rv}, a ->
        # vote count for the current candidate
        cv = Map.get(counts, rk, 0)
        # update result row for candidate
        Map.put(a, rk, Map.update(rv, :votes, 0, &(&1 + cv)))
      end
    )
  end

  # Applies subsequent vote distribution to result for the elected or excluded candidate
  # Returns updated results.
  defp distribute(ballots, result, candidate, weight) do
    counts = ranked_votes(filter_candidates(ballots, [candidate]))

    result =
      Enum.reduce(
        result,
        %{},
        fn {rk, rv}, a ->
          # vote count for the current candidate
          count = Map.get(counts, rk, 0)
          # update result row for candidate
          Map.put(a, rk, Map.update(rv, :votes, 0, &(&1 + Float.round(weight * count, 5))))
        end
      )

    # exhausted count
    ev = Map.get(counts, :exhausted, 0)
    # result row for the current candidate
    rv = Map.get(result, candidate, 0)
    Map.put(result, candidate, Map.put(rv, :exhausted, Float.round(weight * ev, 5)))
  end

end
