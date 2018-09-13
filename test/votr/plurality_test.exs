defmodule Votr.PluralityTest do
  use ExUnit.Case
  doctest Votr.Plurality

  test "plurality" do
    ballots =
      Enum.concat(
        [
          Enum.map(1..16, fn _ -> %{"a" => 1} end),
          Enum.map(1..24, fn _ -> %{"b" => 1} end),
          Enum.map(1..11, fn _ -> %{"c" => 1} end),
          Enum.map(1..17, fn _ -> %{"d" => 1} end)
        ]
      )

    result = IO.inspect(Votr.Plurality.eval(ballots, 1))

    c = Map.get(result, "c")
    assert c.round == 1
    assert c.votes == 11
    assert c.exhausted == 11
    assert c.status == :excluded

    c = Map.get(result, "a")
    assert c.round == 2
    assert c.votes == 16
    assert c.exhausted == 16
    assert c.status == :excluded

    c = Map.get(result, "d")
    assert c.round == 3
    assert c.votes == 17
    assert c.exhausted == 17
    assert c.status == :excluded

    c = Map.get(result, "b")
    assert c.round == 4
    assert c.votes == 24
    assert c.status == :elected
  end

end
