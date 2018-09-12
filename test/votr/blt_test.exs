defmodule Votr.BltTest do
  use ExUnit.Case
  doctest Votr.Blt

  test "parse" do
    # see https://www.opavote.com/help/overview#blt-file-format

    file = """
    4 2          # Four candidates are competing for two seats
    -2           # Bob has withdrawn
    1 4 1 3 2 0  # First ballot
    1 3 4 1 2 0  # Chuck first, Amy second, Diane third, Bob fourth
    1 2 4 1 0    # Bob first, Amy second, Diane third
    1 4 3 0      # Amy first, Chuck second
    6 4 3 0      # Amy first, Chuck second with a weight of 6
    1 0          # An empty ballot
    1 2 - 3 0    # Bob first, no one second, Chuck third
    1 2=3 1 0    # Bob and Chuck first, Diane second
    1 2 3 4 1 0  # Last ballot
    0            # End of ballots marker
    "Diane"      # Candidate 1
    "Bob"        # Candidate 2
    "Chuck"      # Candidate 3
    "Amy"        # Candidate 4
    "Gardening Club Election"  # Title
    """

    lines = String.split(file, "\n")
    election = Votr.Blt.parse(lines)

    # IO.inspect(election)

    assert election.title == "Gardening Club Election"
    assert election.candidates == ["Diane", "Bob", "Chuck", "Amy"]
    assert election.seats == 2
    assert election.withdrawn == [2]
    assert Enum.count(election.ballots) == 14

    [result | _] = Votr.Stv.eval(election.ballots, election.seats)
                   |> Votr.Blt.rekey(election.candidates)

    # IO.inspect(result)

    assert Map.get(result, "Amy").round == 1
    assert Map.get(result, "Diane").round == 2
    assert Map.get(result, "Chuck").round == 3
    assert Map.get(result, "Bob").round == 4
  end
end
