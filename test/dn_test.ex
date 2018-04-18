defmodule Votr.DNTest do
  @moduledoc false

  use ExUnit.Case, async: true

  test "to_string/1" do
    string =
      %{"foo" => "bar"}
      |> DN.to_string()

    assert string == "foo: bar"
  end
end
