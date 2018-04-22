defmodule Votr.Identity.Totp do
  @moduledoc """
  Time-based one-time passwords may be by election officials as a form of MFA to log in.
  """

  @config Application.get_env(:votr, Votr.Identity.Totp)
  @issuer @config[:issuer]
  @algorithm @config[:algorithm]
  @digits @config[:digits]
  @period @config[:period]
  @scratch_codes @config[:scratch_codes]

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
    field(:digits, :integer)
    field(:algorithm, :string)
    field(:period, :integer)
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
      code > :math.pow(10, totp.digits) -> false
      true ->
        t = div(DateTime.to_unix(DateTime.utc_now()), totp.period)
        (t - 1)..(t + 1)
        |> Enum.map(fn t -> calculate_code(t, totp.secret_key, totp.algorithm, totp.digits) end)
        |> Enum.filter(fn c -> code == c end)
        |> Enum.empty?()
        |> Kernel.not()
    end
  end

  def calculate_code(t, secret_key, algorithm \\ @algorithm, digits \\ @digits) do

    # the message to be hashed is the time component as an 0-padded 8-byte bitstring
    l = t
        |> :binary.encode_unsigned()
        |> :binary.bin_to_list()
    msg = -8..-1
          |> Enum.map(fn i -> Enum.at(l, i, 0) end)
          |> :binary.list_to_bin()

    IO.inspect(algorithm)
    hs = :crypto.hmac(algorithm, secret_key, msg)

    # extract a 31 bit value from the hash
    # the offset of the bytes to use comes from the lowest 4 bits of the last byte
    IO.inspect(hs)

    offset = hs
             |> :binary.bin_to_list()
             |> Enum.at(-1)
    offset = (offset &&& 0xF) * 8

    <<_ :: size(offset), code_bytes :: binary - 4, _ :: binary>> = hs
    code = :binary.decode_unsigned(code_bytes) &&& 0x7FFFFFFF
    Integer.mod(code, round(:math.pow(10, digits)))
  end

  def to_principal(%Totp{} = totp) do
    %Principal{
      id: totp.id,
      subject_id: totp.subject_id,
      kind: "totp",
      seq: nil,
      value:
        "#{Base.encode32(totp.secret_key)};#{Enum.join(totp.scratch_codes, ",")};#{algorithm};#{digits};#{period}"
        |> AES.encrypt()
        |> Base.encode64()
    }
  end

  def from_principal(%Principal{} = p) do
    {key, codes, algorithm, digits, period} =
      p.value
      |> Base.decode64!()
      |> AES.decrypt()
      |> String.split(";")

    scratch_codes = codes
                    |> String.split(",")
                    |> Enum.map(&String.to_integer/1)

    %Totp{
      id: p.id,
      subject_id: p.subject_id,
      secret_key: Base.decode32(key),
      scratch_codes: scratch_codes,
      algorithm: String.to_atom(algorithm),
      digits: String.to_integer(digits),
      period: String.to_integer(period)
    }
  end

  def new(subject_id, algorithm \\ @algorithm, digits \\ @digits, period \\ @period) do
    bytes = case algorithm do
      :sha -> 20
      :sha256 -> 32
      :sha512 -> 64
    end

    %Totp{
      subject_id: subject_id,
      secret_key: :crypto.strong_rand_bytes(bytes),
      scratch_codes: Enum.map(1..@scratch_codes, fn _v -> Enum.random(1_000_000..9_999_999) end),
      algorithm: algorithm,
      digits: digits,
      period: period
    }
  end

  def uri(%Totp{} = totp, issuer \\ @issuer) do
    secret = Base.encode32(totp.secret_key)
    subject = HashId.encode(totp.subject_id)
    alg = case totp.algorithm do
      :sha -> "SHA1"
      :sha256 -> "SHA256"
      :sha512 -> "SHA512"
    end
    iss = issuer
    digits = totp.digits
    period = totp.digits

    "otpauth://totp/#{iss}:#{subject}?secret=#{secret}&issuer=#{iss}&algorithm=#{alg}&digits=#{digits}&period=#{period}"
  end
end
