defmodule Votr.Blt do

  @doc """
  Parses a BLT file `stream`.
  The BLT file format is described here: https://www.opavote.com/help/overview#blt-file-format
  Returns a map containing:
  * `seats`: the number of seats to be elected
  * `ballots`: a list of ballots that can be passed to `eval/3`
  * `candidates`: a list of candidate names
  * `withdrawn`: a list of candidate ids that should be filtered from the ballots (optional)
  """
  def parse(stream) do
    # file consists of the following lines
    # :initial    1 line     <number of candidates c> <number of seats s>
    # :ballot     0~1 line   <the candidates that have withdrawn>+
    # :ballot     1~n lines  a ballot (see format below)
    # :ballot     1 line     0 (end of ballots marker)
    # :candidate  c lines    "<name of candidate>"
    # :candidate  1 line     "<name of election>"

    # each ballot has the format
    # <weight> <candidate> <candidate> ...0
    # weight can be used to group identical ballots
    # candidate is the integer id of the candidate (i.e. 1,2,3)
    # candidate may be a - to indicate a skipped vote
    # two candidates may be joined with = to indicate the have equal rank

    Enum.reduce(
      stream,
      %{state: :initial},
      fn line, a ->
        [data | _] = String.split(line, "#", parts: 2)
        data = String.trim(data)

        cond do
          # comment only line
          data == "" ->
            a

          # first line
          a.state == :initial ->
            [c, s] = String.split(data, " ")
            {candidates, _} = Integer.parse(c)
            {seats, _} = Integer.parse(s)

            a
            |> Map.put(:remaining, candidates)
            |> Map.put(:seats, seats)
            |> Map.put(:state, :ballot)
            |> Map.put(:ballots, [])
            |> Map.put(:candidates, [])

          # end of ballots marker line
          a.state == :ballot && data == "0" ->
            Map.put(a, :state, :candidate)

          # withdrawn candidates line
          a.state == :ballot && String.starts_with?(data, "-") ->
            withdrawn =
              Regex.scan(~r/(-\d+)+/, data)
              |> Enum.map(
                   fn [match, _] ->
                     {c, _} = Integer.parse(match)
                     -c
                   end
                 )

            Map.put(a, :withdrawn, withdrawn)

          # ballot line
          a.state == :ballot ->
            [weight | candidates] = String.split(data, " ")
            {weight, _} = Integer.parse(weight)

            ballot =
              Enum.reduce(
                candidates,
                {1, %{}},
                fn term, {rank, ballot} ->
                  case term do
                    "0" ->
                      # end of ballot marker
                      ballot

                    "-" ->
                      # undervote marker
                      {rank + 1, ballot}

                    _ ->
                      {
                        rank + 1,
                        Enum.reduce(
                          String.split(term, "="),
                          ballot,
                          fn c, a ->
                            {c, _} = Integer.parse(c)
                            Map.put(a, c, rank)
                          end
                        )
                      }
                  end
                end
              )

            Map.update!(
              a,
              :ballots,
              fn ballots ->
                Enum.reduce(
                  1..weight,
                  ballots,
                  fn _, a ->
                    [ballot] ++ a
                  end
                )
              end
            )

          a.state == :candidate && a.remaining == 0 ->
            a
            |> Map.put(:title, String.replace(String.trim(data, "\""), "\\", ""))
            |> Map.delete(:remaining)
            |> Map.delete(:state)

          a.state == :candidate ->
            a
            |> Map.update(
                 :candidates,
                 [],
                 fn candidates ->
                   candidates ++ [String.replace(String.trim(data, "\""), "\\", "")]
                 end
               )
            |> Map.update!(:remaining, &(&1 - 1))

          true ->
            a
        end

        # cond
      end
    )

    # reduce
  end

  @doc """
  Takes `results` with numeric candidate keys and returns results
  with the candidate keys from `candidates`.
  """
  def rekey(result, candidates) do
    Enum.reduce(result, %{}, fn {i, v}, a -> Map.put(a, Enum.at(candidates, i - 1), v) end)
  end
end
