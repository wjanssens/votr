defmodule Votr.EncryptedBinary do
  import Votr.AES

  @behaviour Ecto.Type

  def type, do: :string

  def cast(value) do
    {:ok, to_string(value)}
  end

  def dump(plaintext) do
    ciphertext = plaintext
                 |> encrypt
                 |> Base.encode64
    {:ok, ciphertext}
  end

  def load(ciphertext) do
    plaintext = ciphertext
                |> Base.decode64!
                |> decrypt
    {:ok, plaintext}
  end
end
