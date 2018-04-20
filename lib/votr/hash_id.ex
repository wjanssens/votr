defmodule HashId do
  @moduledoc false

  @config Application.get_env(:votr, Votr.AES)
  @salt @config[:salt]
  @min_length @config[:min_length]
  @alphabet @config[:alphabet]

  def encode(id) do
    Hashids.new(salt: @salt, min_length: @min_length, alphabet: @alphabet)
    |> Hashids.encode(id)
  end

  def decode(encoded) do
    Hashids.new(salt: @salt, min_length: @min_length, alphabet: @alphabet)
    |> Hashids.decode(encoded)
  end
end
