defmodule Votr.Identity.DN do
  def to_string(map) do
    map
    |> Enum.filter(fn {_k, v} -> not is_nil(v) end)
    |> Enum.map_join(",", fn {k, v} -> "#{k}=#{escape(v)}" end)
  end

  def from_string(binary) do
    binary
    |> String.split(",")
    |> Enum.map(fn p -> String.split(p, "=") end)
    |> Map.new(fn [k, v] -> {k, unescape(v)} end)
  end

  defp escape(str) do
    str
    |> String.replace("\\", "\\")
    |> String.replace(",", "\,")
    |> String.replace("=", "\=")
  end

  defp unescape(str) do
    str
    |> String.replace("\\,", ",")
    |> String.replace("\\=", "=")
    |> String.replace("\\\\", "\\")
  end
end
