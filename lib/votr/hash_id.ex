defmodule HashId do
  @moduledoc false

  @config Application.get_env(:votr, Votr.HashId)
  @salt @config[:salt]
  @min_length @config[:min_length]
  @alphabet @config[:alphabet]

  @coder Hashids.new(salt: @salt, min_length: @min_length, alphabet: @alphabet)

  def encode(id) do
    Hashids.encode(@coder, id)
  end

  def decode(encoded) do
    Enum.at(Hashids.decode!(@coder, encoded), 0)
  end
end
