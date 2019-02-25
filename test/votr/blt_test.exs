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
    assert Enum.count(election.ballots) == 9

    result = Votr.Stv.eval(election.ballots, election.seats)
                   |> Votr.Blt.rekey(election.candidates)

    # IO.inspect(result)

    # in round 0 (initial first choice counts)
    assert Map.get(Enum.at(result, 4), "Amy").votes == 8
    assert Map.get(Enum.at(result, 4), "Bob").votes == 4
    assert Map.get(Enum.at(result, 4), "Chuck").votes == 1
    assert Map.get(Enum.at(result, 4), "Diane").votes == 0

    # in round 1 Amy is elected and their votes transfer to Chuck and Diane
    assert Map.get(Enum.at(result, 3), "Amy").surplus == 3
    assert Map.get(Enum.at(result, 3), "Amy").status == :elected
    assert Map.get(Enum.at(result, 3), "Amy").votes == 5
    assert Map.get(Enum.at(result, 3), "Chuck").received == 2.625
    assert Map.get(Enum.at(result, 3), "Chuck").votes == 3.625
    assert Map.get(Enum.at(result, 3), "Diane").received == 0.375
    assert Map.get(Enum.at(result, 3), "Diane").votes == 0.375

    # in round 2 Diane is excluded and their votes transfer to Bob and Chuck
    assert Map.get(Enum.at(result, 2), "Diane").surplus == 0.375
    assert Map.get(Enum.at(result, 2), "Diane").status == :excluded
    assert Map.get(Enum.at(result, 2), "Diane").votes == 0
    assert Map.get(Enum.at(result, 2), "Bob").received == 0.25
    assert Map.get(Enum.at(result, 2), "Bob").votes == 4.25
    assert Map.get(Enum.at(result, 2), "Chuck").received == 0.125
    assert Map.get(Enum.at(result, 2), "Chuck").votes == 3.75

    # in round 3 Chuck is excluded and their votes transfer to Bob and exhausted
    assert Map.get(Enum.at(result, 1), "Chuck").surplus == 3.75
    assert Map.get(Enum.at(result, 1), "Chuck").status == :excluded
    assert Map.get(Enum.at(result, 1), "Chuck").votes == 0
    assert Map.get(Enum.at(result, 1), "Bob").received == 0.83333
    assert Map.get(Enum.at(result, 1), "Bob").votes == 5.08333
    assert Map.get(Enum.at(result, 1), :exhausted).received == 2.91667
    assert Map.get(Enum.at(result, 1), :exhausted).votes == 2.91667

    # in round 4 Bob is elected
    assert Map.get(Enum.at(result, 0), "Bob").surplus == 0.08333000000000013
    assert Map.get(Enum.at(result, 0), "Bob").status == :elected
    assert Map.get(Enum.at(result, 0), "Bob").votes == 5
  end
end
