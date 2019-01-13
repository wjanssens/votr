defmodule Votr.HashId do
  @moduledoc false

  @config Application.get_env(:votr, Votr.HashId)
  @salt @config[:salt]
  @min_length @config[:min_length]
  @alphabet @config[:alphabet]

  @coder Hashids.new(salt: @salt, min_len: @min_length, alphabet: @alphabet)

  def encode(id) do
    Hashids.encode(@coder, id)
  end

  def decode(encoded) do
    sanitized = encoded
                |> String.upcase()
                |> String.replace(~r/[^A-Z0-9]/, "", global: true)
                |> String.replace("Q", "0")
                |> String.replace("O", "0")
                |> String.replace("I", "1")
    Enum.at(Hashids.decode!(@coder, sanitized), 0)
  end
end
