defmodule Votr.Identity.Totp do
  @moduledoc """
  Time-based one-time passwords may be by election officials as a form of MFA to log in.
  """

  use Ecto.Schema
  alias Votr.Identity.Totp
  alias Votr.Identity.Principal
  alias Votr.AES
  import Bitwise

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:secret_key, :binary)
    field(:scratch_codes, {:array, :integer})
  end

  def select(id) do
    Principal.select(id, &from_principal/1)
  end

  def select_by_subject_id(subject_id) do
    case Principal.select_by_subject_id(subject_id, "totp", &from_principal/1)
         |> Enum.at(0)
      do
      nil -> {:error, :not_found}
      totp -> {:ok, totp}
    end
  end

  def verify(%Totp{} = totp, code) do
    cond do
      code < 0 -> false
      code > 1_000_000 -> false
      true ->
        t = div(DateTime.to_unix(DateTime.utc_now()), 30)
        (t - 1)..(t + 1)
        |> Enum.map(fn t -> calculate_code(totp.secret_key, t) end)
        |> Enum.filter(fn c -> code == c end)
        |> Enum.empty?()
        |> Kernel.not()
    end
  end

  def calculate_code(secret_key, t) do

    # the message to be hashed is the time component as an 0-padded 8-byte bitstring
    l = t
        |> :binary.encode_unsigned()
        |> :binary.bin_to_list()
    msg = -8..-1
          |> Enum.map(fn i -> Enum.at(l, i, 0) end)
          |> :binary.list_to_bin()

    hs = :crypto.hmac(:sha, secret_key, msg)

    # extract a 31 bit value from the hash
    # the offset of the bytes to use comes from the lowest 4 bits of the last byte
    <<_ :: binary - 19, offset :: integer>> = hs
    offset = (offset &&& 0xF) * 8

    <<_ :: size(offset), code_bytes :: binary - 4, _ :: binary>> = hs
    code = :binary.decode_unsigned(code_bytes) &&& 0x7FFFFFFF
    Integer.mod(code, 1_000_000)
  end

  def to_principal(%Totp{} = totp) do
    %Principal{
      id: totp.id,
      subject_id: totp.subject_id,
      kind: "totp",
      seq: nil,
      value:
        "#{Base.encode32(totp.secret_key)};#{Enum.join(totp.scratch_codes, ",")}"
        |> AES.encrypt()
        |> Base.encode64()
    }
  end

  def from_principal(%Principal{} = p) do
    {key, codes} =
      p.value
      |> Base.decode64!()
      |> AES.decrypt()
      |> String.split(";")

    {secret_key, scratch_codes} =
      {
        Base.decode32(key),
        codes
        |> String.split(",")
        |> Enum.map(fn c -> Integer.parse(c) end)
      }

    %Totp{
      id: p.id,
      subject_id: p.subject_id,
      secret_key: secret_key,
      scratch_codes: scratch_codes
    }
  end

  def new() do
    %Totp{
      secret_key: :crypto.strong_rand_bytes(10),
      scratch_codes: Enum.map(1..10, fn _v -> Enum.random(1_000_000..9_999_999) end)
    }
  end

  def new(str) do
    [secret, scratch_codes] = String.split(str, ";")

    %Totp{
      secret_key: Base.decode32(secret),
      scratch_codes: scratch_codes
                     |> String.split(",")
                     |> Enum.map(&String.to_integer/1)
    }
  end

  def uri(secret_key, issuer, uid) do
    secret = Base.encode32(secret_key)

    "otpauth://totp/#{issuer}:#{uid}?secret=#{secret}&issuer=#{issuer}&algorithm=sha1&digits=6&period=30"
  end
end
