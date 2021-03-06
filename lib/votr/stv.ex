# TODO implement Borda method
# TODO implement Condorcet method
# TODO implement Block Plurality (multiple seats, unranked votes)
# TODO implement dynamic vs static threshold option
# TODO implement STV tie breaking options (backwards, random)
# TODO implement overvote and undervote handling options and reporting
# TODO implement Meek STV
# TODO implement Baas STV
# TODO implement weighted votes

defmodule Votr.Stv do
  @moduledoc """
  Provides Ranked (STV, IRV), and Unranked (FPTP) ballot evaluation.
  * STV uses a quota to determine when a candidate is elected in rounds.
  	Droop, Hare, Impirali, and Hagenbach Bischoff quotas are available.
  * IRV is a degenerate case of STV where only one seat is elected,
  * FPTP is a degenerate case of IRV where ballots have no rankings and thus
    no distribution can be performed.
  """

  @doc """
  Evaluates an election.
  * `ballots` a list of ballots;
  	with ranked votes for STV and IRV, or unranked votes for FPTP.
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
  [ %{weight: 1.5, vote: %{"a" => 1, "b" => 2, ...} },
    %{weight: 1.0, vote: %{"c" => 1, "d" => 2, ...} },
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
      * `:threshold` - the quota will be a `:whole` number or a `:fractional` number
  """
  def eval(ballots, seats, options \\ []) do
    # find the unique list of candidates from all the ballots
    candidates =
      ballots
      |> Stream.map(fn b -> b.candidates end)
      |> Stream.flat_map(fn v -> Map.keys(v) end)
      |> Stream.uniq()

    # create a result that has an empty entry for every candidate
    # and perform the initial vote distribution
    this_round =
      candidates
      |> Enum.reduce(%{}, fn c, acc -> Map.put(acc, c, %{votes: 0}) end)
      |> distribute(ranked_votes(ballots))
      |> Map.put(:exhausted, %{votes: 0})

    sum = ballots
          |> Enum.map(fn b -> b.weight end)
          |> Enum.sum()
    Enum.count(ballots)

    quota =
      case seats do
        1 ->
          # make the quota a pure majority (equivalent to hagenbach_bischoff)
          sum / 2
        _ ->
          # calculate the number of votes it takes to be elected
          case Keyword.get(options, :quota, :droop) do
            :imperali -> sum / (seats + 2)
            :hare -> sum / seats
            :hagenbach_bischoff -> Float.floor(sum / (seats + 1))
            _ -> sum / (seats + 1) + 1
          end
      end

    quota =
      case Keyword.get(options, :threshold, :whole) do
        :fractional -> quota
        _ -> Float.floor(quota)
      end

    eval([this_round], ballots, 1, 0, seats, quota, options)
  end

  # Recursively evaluate the subsequent rounds of the ranked election.
  # Returns updated results.
  defp eval(result, ballots, round, elected, seats, quota, options \\ []) do
    [last_round | _] = result

    remaining = last_round
                |> Stream.filter(fn {k, _} -> k != :exhausted end)
                |> Enum.count(fn {_, v} -> !Map.has_key?(v, :status) end)

    cond do
      seats == elected ->
        # all the seats are filled so end the recursion
        result

      remaining == 1 ->
        # only one canditate left standing, so they are elected regardless of meeting quota
        {elected_candidate, elected_result} =
          last_round
          |> Stream.filter(fn {k, _} -> k != :exhausted end)
          |> Enum.find(fn {_, v} -> !Map.has_key?(v, :status) end)

        elected_result =
          elected_result
          |> Map.delete(:received)
          |> Map.put(:surplus, elected_result.votes - quota)
          |> Map.put(:status, :elected)
          |> Map.put(:votes, quota)

        this_round = last_round
                     |> Map.put(elected_candidate, elected_result)
                     |> Map.put(:exhausted, Map.delete(Map.get(last_round, :exhausted), :received))

        [this_round | result]

      true ->
        # find the candidate with the most votes
        {elected_candidate, elected_result} =
          last_round
          |> Stream.filter(fn {k, _} -> k != :exhausted end)
          |> Stream.filter(fn {_, v} -> !Map.has_key?(v, :status) end)
          |> Enum.max_by(fn {_, v} -> v.votes end)

        if elected_result.votes >= quota do
          # candidate has enough votes to be elected
          surplus = elected_result.votes - quota

          # update the result for the elected candidate
          elected_result =
            elected_result
            |> Map.delete(:received)
            |> Map.put(:status, :elected)
            |> Map.put(:surplus, surplus)
            |> Map.put(:votes, quota)

          this_round = last_round
                       |> Map.put(elected_candidate, elected_result)
                       |> distribute(ballots, elected_candidate, surplus)

          # perform the next round using ballots that exclude the elected candidate
          eval([this_round | result], ballots, round + 1, elected + 1, seats, quota, options)
        else
          # a candidate must be excluded
          # find the candidate with the least votes
          {excluded_candidate, excluded_result} =
            last_round
            |> Stream.filter(fn {k, _} -> k != :exhausted end)
            |> Stream.filter(fn {_, v} -> !Map.has_key?(v, :status) end)
            |> Enum.min_by(fn {_, v} -> v.votes end)

          surplus = excluded_result.votes;

          # update the result for the excluded candidate
          excluded_result =
            excluded_result
            |> Map.delete(:received)
            |> Map.put(:status, :excluded)
            |> Map.put(:surplus, surplus)
            |> Map.put(:votes, 0)

          this_round = last_round
                       |> Map.put(excluded_candidate, excluded_result)
                       |> distribute(ballots, excluded_candidate, surplus)

          # perform the next round using ballots that exclude the elected candidate
          eval([this_round | result], ballots, round + 1, elected, seats, quota, options)
        end
    end
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

  # Returns a map of how many votes a candidates has obtained
  defp ranked_votes(ballots) do
    # count the number of "first" choice votes for each candidate
    ballots
    |> Stream.map(
         fn b ->
           # vote(s) with the lowest rank
           # candidate from the vote
           c = b.candidates
               |> Enum.filter(fn {k, _} -> k != :exhausted end)
               |> Enum.min_by(fn {_, v} -> v end, fn -> {:exhausted, 0} end)
               |> Tuple.to_list()
               |> List.first()
           %{w: b.weight, c: c}
         end
       )
    |> Enum.reduce(%{}, fn %{c: c, w: w}, a -> Map.update(a, c, 1 * w, &(&1 + (1 * w))) end)
  end

  # Applies initial vote distribution to result for all candidates.
  # Returns updated results.
  defp distribute(result, counts) do
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
  defp distribute(result, ballots, candidate, surplus) do
    # ignore all previously elected and excluded candidates during distribution
    ineligible = result
                 |> Enum.reduce(
                      [],
                      fn {c, v}, acc ->
                        if Map.has_key?(v, :status) do
                          [c | acc]
                        else
                          acc
                        end
                      end
                    )
                 |> List.delete(candidate)

    # find the ballots that were used to elect / exclude this candidate
    ballots_to_distribute = ballots
                            |> Stream.map(
                                 fn ballot ->
                                   Map.update!(
                                     ballot,
                                     :candidates,
                                     fn candidates ->
                                       candidates
                                       |> Map.drop([:exhausted | ineligible])
                                     end
                                   )
                                 end
                               )
                            |> Stream.filter(
                                 fn ballot ->
                                   ballot.candidates
                                   |> Enum.min_by(fn {_, rank} -> rank end, fn -> {:exhausted, 0} end)
                                   |> Tuple.to_list()
                                   |> Enum.member?(candidate)
                                 end
                               )
                            |> Enum.map(
                                 fn ballot ->
                                   Map.update!(
                                     ballot,
                                     :candidates,
                                     fn candidates ->
                                       candidates
                                       |> Map.drop([candidate])
                                     end
                                   )
                                 end
                               )

    # the weight of the distribution, not the voter's weight
    weight = ballots_to_distribute
             |> Enum.map(fn ballot -> ballot.weight end)
             |> Enum.sum

    counts = ranked_votes(ballots_to_distribute)

    result
    |> Enum.reduce(
         %{},
         fn {rk, rv}, a ->
           if Map.has_key?(rv, :status) do
             Map.put(a, rk, rv)
           else
             # vote count for the current candidate
             count = Map.get(counts, rk, 0)
             # update result row for candidate
             # TODO implement configurable precision
             received = Float.round(surplus / weight * count, 5)
             if received > 0 do
               rv = rv
                    |> Map.delete(:surplus)
                    |> Map.put(:received, received)
                    |> Map.update(:votes, received, &(&1 + received))
               Map.put(a, rk, rv)
             else
               rv = rv
                    |> Map.delete(:received)
                    |> Map.delete(:surplus)
               Map.put(a, rk, rv)
             end
           end
         end
       )
  end

end
