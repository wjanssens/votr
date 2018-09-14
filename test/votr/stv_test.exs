defmodule Votr.StvTest do
  use ExUnit.Case
  doctest Votr.Stv

  test "stv" do
    # see https://en.wikipedia.org/wiki/Counting_single_transferable_votes

    ballots =
      Enum.concat(
        [
          Enum.map(1..16, fn _ -> %{"a" => 1, "b" => 2, "c" => 3, "d" => 4} end),
          Enum.map(1..24, fn _ -> %{"a" => 1, "b" => 3, "c" => 2, "d" => 4} end),
          Enum.map(1..17, fn _ -> %{"a" => 2, "b" => 3, "c" => 4, "d" => 1} end)
        ]
      )

    result = Votr.Stv.eval(ballots, 2)

    # in round 0 (initial first choice counts)
    assert Map.get(Enum.at(result, 3), "a").votes == 40
    assert Map.get(Enum.at(result, 3), "b").votes == 0
    assert Map.get(Enum.at(result, 3), "c").votes == 0
    assert Map.get(Enum.at(result, 3), "d").votes == 17

    # in round 1 a is elected and their surplus transfer to b and c
    assert Map.get(Enum.at(result, 2), "a").surplus == 20
    assert Map.get(Enum.at(result, 2), "a").status == :elected
    assert Map.get(Enum.at(result, 2), "a").votes == 20
    assert Map.get(Enum.at(result, 2), "b").received == 8
    assert Map.get(Enum.at(result, 2), "b").votes == 8
    assert Map.get(Enum.at(result, 2), "c").received == 12
    assert Map.get(Enum.at(result, 2), "c").votes == 12

    # in round 2 b is excluded and their surplus transfer to c
    assert Map.get(Enum.at(result, 1), "b").surplus == 8
    assert Map.get(Enum.at(result, 1), "b").status == :excluded
    assert Map.get(Enum.at(result, 1), "b").votes == 0
    assert Map.get(Enum.at(result, 1), "c").received == 8
    assert Map.get(Enum.at(result, 1), "c").votes == 20

    # in round 3 c is elected
    assert Map.get(Enum.at(result, 0), "c").surplus == 0
    assert Map.get(Enum.at(result, 0), "c").status == :elected
    assert Map.get(Enum.at(result, 0), "c").votes == 20
  end

  test "animal_stv_1" do
    # see https://www.youtube.com/watch?v=l8XOZJkozfI

    ballots =
      Enum.concat(
        [
          Enum.map(1..05, fn _ -> %{"tarsier" => 1, "gorilla" => 2} end),
          Enum.map(1..28, fn _ -> %{"gorilla" => 1} end),
          Enum.map(1..33, fn _ -> %{"monkey" => 1} end),
          Enum.map(1..21, fn _ -> %{"tiger" => 1} end),
          Enum.map(1..13, fn _ -> %{"lynx" => 1, "tiger" => 2} end)
        ]
      )

    # run the election with Droop quota
    result = Votr.Stv.eval(ballots, 3)

    # in round 0 (initial first choice counts)
    assert Map.get(Enum.at(result, 5), "gorilla").votes == 28
    assert Map.get(Enum.at(result, 5), "lynx").votes == 13
    assert Map.get(Enum.at(result, 5), "monkey").votes == 33
    assert Map.get(Enum.at(result, 5), "tarsier").votes == 5
    assert Map.get(Enum.at(result, 5), "tiger").votes == 21

    # in round 1 monkey is elected and their surplus is exhausted
    assert Map.get(Enum.at(result, 4), "monkey").surplus == 7
    assert Map.get(Enum.at(result, 4), "monkey").status == :elected
    assert Map.get(Enum.at(result, 4), "monkey").votes == 26
    assert Map.get(Enum.at(result, 4), :exhausted).received == 7
    assert Map.get(Enum.at(result, 4), :exhausted).votes == 7

    # in round 2 gorilla is elected and their surplus is exhausted
    assert Map.get(Enum.at(result, 3), "gorilla").surplus == 2
    assert Map.get(Enum.at(result, 3), "gorilla").status == :elected
    assert Map.get(Enum.at(result, 3), "gorilla").votes == 26
    assert Map.get(Enum.at(result, 3), :exhausted).received == 2
    assert Map.get(Enum.at(result, 3), :exhausted).votes == 9

    # in round 3 tarsier is excluded and their surplus is exhausted
    assert Map.get(Enum.at(result, 2), "tarsier").surplus == 5
    assert Map.get(Enum.at(result, 2), "tarsier").status == :excluded
    assert Map.get(Enum.at(result, 2), "tarsier").votes == 0
    assert Map.get(Enum.at(result, 2), :exhausted).received == 5
    assert Map.get(Enum.at(result, 2), :exhausted).votes == 14

    # in round 4 lynx is excluded and their surplus is transferred to tiger
    assert Map.get(Enum.at(result, 1), "lynx").surplus == 13
    assert Map.get(Enum.at(result, 1), "lynx").status == :excluded
    assert Map.get(Enum.at(result, 1), "lynx").votes == 0
    assert Map.get(Enum.at(result, 1), "tiger").received == 13
    assert Map.get(Enum.at(result, 1), "tiger").votes == 34

    # in round 5 tiger is elected
    assert Map.get(Enum.at(result, 0), "tiger").surplus == 8
    assert Map.get(Enum.at(result, 0), "tiger").status == :elected
    assert Map.get(Enum.at(result, 0), "tiger").votes == 26

    # run the election with Hare quota
    result = Votr.Stv.eval(ballots, 3, quota: :hare)

    # in round 0 (initial first choice counts)
    assert Map.get(Enum.at(result, 5), "gorilla").votes == 28
    assert Map.get(Enum.at(result, 5), "lynx").votes == 13
    assert Map.get(Enum.at(result, 5), "monkey").votes == 33
    assert Map.get(Enum.at(result, 5), "tarsier").votes == 5
    assert Map.get(Enum.at(result, 5), "tiger").votes == 21

    # in round 1 monkey is elected
    assert Map.get(Enum.at(result, 4), "monkey").surplus == 0
    assert Map.get(Enum.at(result, 4), "monkey").status == :elected
    assert Map.get(Enum.at(result, 4), "monkey").votes == 33

    # in round 2 tarsier is excluded and their surplus is transferred to gorilla
    assert Map.get(Enum.at(result, 3), "tarsier").surplus == 5
    assert Map.get(Enum.at(result, 3), "tarsier").status == :excluded
    assert Map.get(Enum.at(result, 3), "tarsier").votes == 0
    assert Map.get(Enum.at(result, 3), "gorilla").received == 5
    assert Map.get(Enum.at(result, 3), "gorilla").votes == 33

    # in round 3 gorilla is elected
    assert Map.get(Enum.at(result, 2), "gorilla").surplus == 0
    assert Map.get(Enum.at(result, 2), "gorilla").status == :elected
    assert Map.get(Enum.at(result, 2), "gorilla").votes == 33

    # in round 4 lynx is excluded and their surplus is transferred to tiger
    assert Map.get(Enum.at(result, 1), "lynx").surplus == 13
    assert Map.get(Enum.at(result, 1), "lynx").status == :excluded
    assert Map.get(Enum.at(result, 1), "lynx").votes == 0
    assert Map.get(Enum.at(result, 1), "tiger").received == 13
    assert Map.get(Enum.at(result, 1), "tiger").votes == 34

    # in round 5 tiger is elected
    assert Map.get(Enum.at(result, 0), "tiger").surplus == 1
    assert Map.get(Enum.at(result, 0), "tiger").status == :elected
    assert Map.get(Enum.at(result, 0), "tiger").votes == 33
  end

  test "animal_stv_2" do
    # see https://www.youtube.com/watch?v=l8XOZJkozfI

    ballots =
      Enum.concat(
        [
          Enum.map(1..65, fn _ -> %{"white tiger" => 1, "tiger" => 2} end),
          Enum.map(1..01, fn _ -> %{"tiger" => 1, "white tiger" => 2} end),
          Enum.map(1..16, fn _ -> %{"silverback" => 1, "gorilla" => 2} end),
          Enum.map(1..18, fn _ -> %{"gorilla" => 1, "silverback" => 2} end)
        ]
      )

    # run the election with Droop quota
    result = Votr.Stv.eval(ballots, 3)

    # in round 0 (initial first choice counts)
    assert Map.get(Enum.at(result, 4), "gorilla").votes == 18
    assert Map.get(Enum.at(result, 4), "silverback").votes == 16
    assert Map.get(Enum.at(result, 4), "tiger").votes == 1
    assert Map.get(Enum.at(result, 4), "white tiger").votes == 65

    # in round 1 white tiger is elected and their surplus transfers to tiger
    assert Map.get(Enum.at(result, 3), "white tiger").surplus == 39
    assert Map.get(Enum.at(result, 3), "white tiger").status == :elected
    assert Map.get(Enum.at(result, 3), "white tiger").votes == 26
    assert Map.get(Enum.at(result, 3), "tiger").received == 39
    assert Map.get(Enum.at(result, 3), "tiger").votes == 40

    # in round 2 tiger is elected and their surplus is exhausted
    assert Map.get(Enum.at(result, 2), "tiger").surplus == 14
    assert Map.get(Enum.at(result, 2), "tiger").status == :elected
    assert Map.get(Enum.at(result, 2), "tiger").votes == 26
    assert Map.get(Enum.at(result, 2), :exhausted).received == 14
    assert Map.get(Enum.at(result, 2), :exhausted).votes == 14

    # in round 3 tiger is excluded and their surplus is transfers to gorilla
    assert Map.get(Enum.at(result, 1), "silverback").surplus == 16
    assert Map.get(Enum.at(result, 1), "silverback").status == :excluded
    assert Map.get(Enum.at(result, 1), "silverback").votes == 0
    assert Map.get(Enum.at(result, 1), "gorilla").received == 16
    assert Map.get(Enum.at(result, 1), "gorilla").votes == 34

    # in round 4 gorilla is elected
    assert Map.get(Enum.at(result, 0), "gorilla").surplus == 8
    assert Map.get(Enum.at(result, 0), "gorilla").status == :elected
    assert Map.get(Enum.at(result, 0), "gorilla").votes == 26

    # run the election with Hare quota
    result = Votr.Stv.eval(ballots, 3, quota: :hare)

    # in round 0 (initial first choice counts)
    assert Map.get(Enum.at(result, 4), "gorilla").votes == 18
    assert Map.get(Enum.at(result, 4), "silverback").votes == 16
    assert Map.get(Enum.at(result, 4), "tiger").votes == 1
    assert Map.get(Enum.at(result, 4), "white tiger").votes == 65

    # in round 1 white tiger is elected and their surplus transfers to tiger
    assert Map.get(Enum.at(result, 3), "white tiger").surplus == 32
    assert Map.get(Enum.at(result, 3), "white tiger").status == :elected
    assert Map.get(Enum.at(result, 3), "white tiger").votes == 33
    assert Map.get(Enum.at(result, 3), "tiger").received == 32
    assert Map.get(Enum.at(result, 3), "tiger").votes == 33

    # in round 2 tiger is elected
    assert Map.get(Enum.at(result, 2), "tiger").surplus == 0
    assert Map.get(Enum.at(result, 2), "tiger").status == :elected
    assert Map.get(Enum.at(result, 2), "tiger").votes == 33

    # in round 3 tiger is excluded and their surplus is transfers to gorilla
    assert Map.get(Enum.at(result, 1), "silverback").surplus == 16
    assert Map.get(Enum.at(result, 1), "silverback").status == :excluded
    assert Map.get(Enum.at(result, 1), "silverback").votes == 0
    assert Map.get(Enum.at(result, 1), "gorilla").received == 16
    assert Map.get(Enum.at(result, 1), "gorilla").votes == 34

    # in round 4 gorilla is elected
    assert Map.get(Enum.at(result, 0), "gorilla").surplus == 1
    assert Map.get(Enum.at(result, 0), "gorilla").status == :elected
    assert Map.get(Enum.at(result, 0), "gorilla").votes == 33

  end

  test "animal_stv_3" do
    # see https://www.youtube.com/watch?v=Ac9070OIMUg

    ballots =
      Enum.concat(
        [
          Enum.map(1..05, fn _ -> %{"tarsier" => 1, "silverback" => 2} end),
          Enum.map(1..10, fn _ -> %{"gorilla" => 1, "tarsier" => 2, "silverback" => 3} end),
          Enum.map(1..22, fn _ -> %{"gorilla" => 1, "silverback" => 2} end),
          Enum.map(1..03, fn _ -> %{"silverback" => 1} end),
          Enum.map(1..33, fn _ -> %{"owl" => 1, "turtle" => 2} end),
          Enum.map(1..01, fn _ -> %{"turtle" => 1} end),
          Enum.map(1..01, fn _ -> %{"snake" => 1, "turtle" => 2} end),
          Enum.map(1..16, fn _ -> %{"tiger" => 1} end),
          Enum.map(1..04, fn _ -> %{"lynx" => 1, "tiger" => 2} end),
          Enum.map(1..02, fn _ -> %{"jackalope" => 1} end),
          Enum.map(1..02, fn _ -> %{"buffalo" => 1, "jackalope" => 2} end),
          Enum.map(1..01, fn _ -> %{"buffalo" => 1, "jackalope" => 2, "turtle" => 3} end)
        ]
      )

    # this is a really interesting comparison of Hare vs Droop quota
    # in both cases the same candidates are elected, but in completely different
    # rounds and with Turtle having a clear win with Droop but only winning by
    # default with Hare

    # run the election with Droop quota
    result = Votr.Stv.eval(ballots, 5)

    # in round 0 (initial first choice counts)
    assert Map.get(Enum.at(result, 10), "buffalo").votes == 3
    assert Map.get(Enum.at(result, 10), "gorilla").votes == 32
    assert Map.get(Enum.at(result, 10), "jackalope").votes == 2
    assert Map.get(Enum.at(result, 10), "lynx").votes == 4
    assert Map.get(Enum.at(result, 10), "owl").votes == 33
    assert Map.get(Enum.at(result, 10), "silverback").votes == 3
    assert Map.get(Enum.at(result, 10), "snake").votes == 1
    assert Map.get(Enum.at(result, 10), "tarsier").votes == 5
    assert Map.get(Enum.at(result, 10), "tiger").votes == 16
    assert Map.get(Enum.at(result, 10), "turtle").votes == 1

    # in round 1 owl is elected and their surplus transfer to turtle
    assert Map.get(Enum.at(result, 9), "owl").surplus == 16
    assert Map.get(Enum.at(result, 9), "owl").status == :elected
    assert Map.get(Enum.at(result, 9), "owl").votes == 17
    assert Map.get(Enum.at(result, 9), "turtle").received == 16
    assert Map.get(Enum.at(result, 9), "turtle").votes == 17

    # in round 2 gorilla is elected and their surplus transfer to silverback and tarsier
    assert Map.get(Enum.at(result, 8), "gorilla").surplus == 15
    assert Map.get(Enum.at(result, 8), "gorilla").status == :elected
    assert Map.get(Enum.at(result, 8), "gorilla").votes == 17
    assert Map.get(Enum.at(result, 8), "silverback").received == 10.3125
    assert Map.get(Enum.at(result, 8), "silverback").votes == 13.3125
    assert Map.get(Enum.at(result, 8), "tarsier").received == 4.6875
    assert Map.get(Enum.at(result, 8), "tarsier").votes == 9.6875

    # in round 3 turtle is elected
    assert Map.get(Enum.at(result, 7), "turtle").surplus == 0
    assert Map.get(Enum.at(result, 7), "turtle").status == :elected
    assert Map.get(Enum.at(result, 7), "turtle").votes == 17

    # in round 4 snake is excluded and their surplus is exhausted
    assert Map.get(Enum.at(result, 6), "snake").surplus == 1
    assert Map.get(Enum.at(result, 6), "snake").status == :excluded
    assert Map.get(Enum.at(result, 6), "snake").votes == 0
    assert Map.get(Enum.at(result, 6), :exhausted).received == 1
    assert Map.get(Enum.at(result, 6), :exhausted).votes == 1

    # in round 5 jackalope is excluded and their surplus is exhausted
    assert Map.get(Enum.at(result, 5), "jackalope").surplus == 2
    assert Map.get(Enum.at(result, 5), "jackalope").status == :excluded
    assert Map.get(Enum.at(result, 5), "jackalope").votes == 0
    assert Map.get(Enum.at(result, 5), :exhausted).received == 2
    assert Map.get(Enum.at(result, 5), :exhausted).votes == 3

    # in round 6 buffalo is excluded and their surplus is exhausted
    assert Map.get(Enum.at(result, 4), "buffalo").surplus == 3
    assert Map.get(Enum.at(result, 4), "buffalo").status == :excluded
    assert Map.get(Enum.at(result, 4), "buffalo").votes == 0
    assert Map.get(Enum.at(result, 4), :exhausted).received == 3
    assert Map.get(Enum.at(result, 4), :exhausted).votes == 6

    # in round 7 lynx is excluded and their surplus is transferred to tiger
    assert Map.get(Enum.at(result, 3), "lynx").surplus == 4
    assert Map.get(Enum.at(result, 3), "lynx").status == :excluded
    assert Map.get(Enum.at(result, 3), "lynx").votes == 0
    assert Map.get(Enum.at(result, 3), "tiger").received == 4
    assert Map.get(Enum.at(result, 3), "tiger").votes == 20

    # in round 8 tiger is elected and their surplus is exhausted
    assert Map.get(Enum.at(result, 2), "tiger").surplus == 3
    assert Map.get(Enum.at(result, 2), "tiger").status == :elected
    assert Map.get(Enum.at(result, 2), "tiger").votes == 17
    assert Map.get(Enum.at(result, 2), :exhausted).received == 3
    assert Map.get(Enum.at(result, 2), :exhausted).votes == 9

    # in round 9 tiger is excluded and their surplus is transferred to silverback
    assert Map.get(Enum.at(result, 1), "tarsier").surplus == 9.6875
    assert Map.get(Enum.at(result, 1), "tarsier").status == :excluded
    assert Map.get(Enum.at(result, 1), "tarsier").votes == 0
    assert Map.get(Enum.at(result, 1), "silverback").received == 9.6875
    assert Map.get(Enum.at(result, 1), "silverback").votes == 23

    # in round 10 silverback is elected
    assert Map.get(Enum.at(result, 0), "silverback").surplus == 6
    assert Map.get(Enum.at(result, 0), "silverback").status == :elected
    assert Map.get(Enum.at(result, 0), "silverback").votes == 17

    # run the election with Hare quota
    result = Votr.Stv.eval(ballots, 5, quota: :hare)

    # in round 0 (initial first choice counts)
    assert Map.get(Enum.at(result, 10), "buffalo").votes == 3
    assert Map.get(Enum.at(result, 10), "gorilla").votes == 32
    assert Map.get(Enum.at(result, 10), "jackalope").votes == 2
    assert Map.get(Enum.at(result, 10), "lynx").votes == 4
    assert Map.get(Enum.at(result, 10), "owl").votes == 33
    assert Map.get(Enum.at(result, 10), "silverback").votes == 3
    assert Map.get(Enum.at(result, 10), "snake").votes == 1
    assert Map.get(Enum.at(result, 10), "tarsier").votes == 5
    assert Map.get(Enum.at(result, 10), "tiger").votes == 16
    assert Map.get(Enum.at(result, 10), "turtle").votes == 1

    # in round 1 owl is elected and their surplus transfer to turtle
    assert Map.get(Enum.at(result, 9), "owl").surplus == 13
    assert Map.get(Enum.at(result, 9), "owl").status == :elected
    assert Map.get(Enum.at(result, 9), "owl").votes == 20
    assert Map.get(Enum.at(result, 9), "turtle").received == 13
    assert Map.get(Enum.at(result, 9), "turtle").votes == 14

    # in round 2 gorilla is elected and their surplus transfer to silverback and tarsier
    assert Map.get(Enum.at(result, 8), "gorilla").surplus == 12
    assert Map.get(Enum.at(result, 8), "gorilla").status == :elected
    assert Map.get(Enum.at(result, 8), "gorilla").votes == 20
    assert Map.get(Enum.at(result, 8), "silverback").received == 8.25
    assert Map.get(Enum.at(result, 8), "silverback").votes == 11.25
    assert Map.get(Enum.at(result, 8), "tarsier").received == 3.75
    assert Map.get(Enum.at(result, 8), "tarsier").votes == 8.75

    # in round 3 snake is excluded and their surplus is tranferred to turtle
    assert Map.get(Enum.at(result, 7), "snake").surplus == 1
    assert Map.get(Enum.at(result, 7), "snake").status == :excluded
    assert Map.get(Enum.at(result, 7), "snake").votes == 0
    assert Map.get(Enum.at(result, 7), "turtle").received == 1
    assert Map.get(Enum.at(result, 7), "turtle").votes == 15

    # in round 4 jackalope is excluded and their surplus is exhausted
    assert Map.get(Enum.at(result, 6), "jackalope").surplus == 2
    assert Map.get(Enum.at(result, 6), "jackalope").status == :excluded
    assert Map.get(Enum.at(result, 6), "jackalope").votes == 0
    assert Map.get(Enum.at(result, 6), :exhausted).received == 2
    assert Map.get(Enum.at(result, 6), :exhausted).votes == 2

    # in round 5 buffalo is excluded and their surplus transferred to turtle and exhausted
    assert Map.get(Enum.at(result, 5), "buffalo").surplus == 3
    assert Map.get(Enum.at(result, 5), "buffalo").status == :excluded
    assert Map.get(Enum.at(result, 5), "buffalo").votes == 0
    assert Map.get(Enum.at(result, 5), "turtle").received == 1
    assert Map.get(Enum.at(result, 5), "turtle").votes == 16
    assert Map.get(Enum.at(result, 5), :exhausted).received == 2
    assert Map.get(Enum.at(result, 5), :exhausted).votes == 4

    # in round 6 lynx is excluded and their surplus is transferred to tiger
    assert Map.get(Enum.at(result, 4), "lynx").surplus == 4
    assert Map.get(Enum.at(result, 4), "lynx").status == :excluded
    assert Map.get(Enum.at(result, 4), "lynx").votes == 0
    assert Map.get(Enum.at(result, 4), "tiger").received == 4
    assert Map.get(Enum.at(result, 4), "tiger").votes == 20

    # in round 7 tiger is elected
    assert Map.get(Enum.at(result, 3), "tiger").surplus == 0
    assert Map.get(Enum.at(result, 3), "tiger").status == :elected
    assert Map.get(Enum.at(result, 3), "tiger").votes == 20

    # in round 8 tarsier is excluded and their surplus is transferred to silverback
    assert Map.get(Enum.at(result, 2), "tarsier").surplus == 8.75
    assert Map.get(Enum.at(result, 2), "tarsier").status == :excluded
    assert Map.get(Enum.at(result, 2), "tarsier").votes == 0
    assert Map.get(Enum.at(result, 2), "silverback").received == 8.75
    assert Map.get(Enum.at(result, 2), "silverback").votes == 20

    # in round 9 silverback is elected
    assert Map.get(Enum.at(result, 1), "silverback").surplus == 0
    assert Map.get(Enum.at(result, 1), "silverback").status == :elected
    assert Map.get(Enum.at(result, 1), "silverback").votes == 20

    # in round 10 turtle is elected (by default)
    assert Map.get(Enum.at(result, 0), "turtle").surplus == -4
    assert Map.get(Enum.at(result, 0), "turtle").status == :elected
    assert Map.get(Enum.at(result, 0), "turtle").votes == 20
    # should votes be 20 or 16?
  end

  test "animal_irv" do
    # see https://www.youtube.com/watch?v=3Y3jE3B8HsE

    ballots =
      Enum.concat(
        [
          Enum.map(1..05, fn _ -> %{"turtle" => 1, "owl" => 2} end),
          Enum.map(1..25, fn _ -> %{"gorilla" => 1, "owl" => 2} end),
          Enum.map(1..25, fn _ -> %{"owl" => 1} end),
          Enum.map(1..30, fn _ -> %{"leopard" => 1} end),
          Enum.map(1..15, fn _ -> %{"tiger" => 1, "leopard" => 2} end)
        ]
      )

    result = Votr.Stv.eval(ballots, 1)

    # in round 0 (initial first choice counts)
    assert Map.get(Enum.at(result, 4), "turtle").votes == 5
    assert Map.get(Enum.at(result, 4), "gorilla").votes == 25
    assert Map.get(Enum.at(result, 4), "owl").votes == 25
    assert Map.get(Enum.at(result, 4), "leopard").votes == 30
    assert Map.get(Enum.at(result, 4), "tiger").votes == 15

    # in round 1 turtle is excluded and their votes transfer to owl
    assert Map.get(Enum.at(result, 3), "turtle").surplus == 5
    assert Map.get(Enum.at(result, 3), "turtle").status == :excluded
    assert Map.get(Enum.at(result, 3), "turtle").votes == 0
    assert Map.get(Enum.at(result, 3), "owl").received == 5
    assert Map.get(Enum.at(result, 3), "owl").votes == 30

    # in round 2 tiger is excluded and their votes transfer to leopard
    assert Map.get(Enum.at(result, 2), "tiger").surplus == 15
    assert Map.get(Enum.at(result, 2), "tiger").status == :excluded
    assert Map.get(Enum.at(result, 2), "tiger").votes == 0
    assert Map.get(Enum.at(result, 2), "leopard").received == 15
    assert Map.get(Enum.at(result, 2), "leopard").votes == 45

    # in round 3 gorilla is excluded and their votes transfer to owl
    assert Map.get(Enum.at(result, 1), "gorilla").surplus == 25
    assert Map.get(Enum.at(result, 1), "gorilla").status == :excluded
    assert Map.get(Enum.at(result, 1), "gorilla").votes == 0
    assert Map.get(Enum.at(result, 1), "owl").received == 25
    assert Map.get(Enum.at(result, 1), "owl").votes == 55

    # in round 4 owl is elected, reaching the quota of 50
    assert Map.get(Enum.at(result, 0), "owl").surplus == 5
    assert Map.get(Enum.at(result, 0), "owl").status == :elected
    assert Map.get(Enum.at(result, 0), "owl").votes == 50
  end

end
