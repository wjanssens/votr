defmodule Votr.DNTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias Votr.Identity.DN

  test "to_string/1" do
    string =
      %{"foo" => "bar", x: "y"}
      |> DN.to_string()

    assert string == "x=y,foo=bar"
  end
end
