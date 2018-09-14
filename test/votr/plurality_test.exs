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

    result = Votr.Plurality.eval(ballots, 1)

    c = Map.get(result, "b")
    assert c.votes == 24
    assert c.status == :elected
  end

  test "plurality_at_large" do
    ballots =
      Enum.concat(
        [
          Enum.map(1..16, fn _ -> %{"a" => 1} end),
          Enum.map(1..24, fn _ -> %{"b" => 1} end),
          Enum.map(1..11, fn _ -> %{"c" => 1} end),
          Enum.map(1..17, fn _ -> %{"d" => 1} end)
        ]
      )

    result = Votr.Plurality.eval(ballots, 3)

    assert Map.get(result, "b").votes == 24
    assert Map.get(result, "b").status == :elected
    assert Map.get(result, "d").votes == 17
    assert Map.get(result, "d").status == :elected
    assert Map.get(result, "a").votes == 16
    assert Map.get(result, "a").status == :elected
    assert Map.get(result, "c").votes == 11
  end

  test "plurality_at_large_2" do
    ballots =
      Enum.concat(
        [
          Enum.map(1..16, fn _ -> %{"a" => 1} end),
          Enum.map(1..24, fn _ -> %{"b" => 1} end),
          Enum.map(1..11, fn _ -> %{"c" => 1} end),
          Enum.map(1..17, fn _ -> %{"d" => 1} end),
          Enum.map(1..05, fn _ -> %{"b" => 1, "c" => 1} end),
          Enum.map(1..10, fn _ -> %{"a" => 1, "d" => 1} end),
          Enum.map(1..20, fn _ -> %{"a" => 1, "b" => 1, "d" => 1} end),
        ]
      )

    result = Votr.Plurality.eval(ballots, 3)

    assert Map.get(result, "b").votes == 49
    assert Map.get(result, "b").status == :elected
    assert Map.get(result, "d").votes == 47
    assert Map.get(result, "d").status == :elected
    assert Map.get(result, "a").votes == 46
    assert Map.get(result, "a").status == :elected
    assert Map.get(result, "c").votes == 16
  end

end
