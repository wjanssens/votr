defmodule Votr.Identity.Totp do
  @moduledoc """
  Time-based one-time passwords may be by election officials as a form of MFA to log in.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.Totp
  alias Votr.Identity.Principal
  alias Votr.AES

  embedded_schema do
    field(:secret_key, :binary)
    field(:scratch_codes, {:array, :integer})
    field(:subject_id, :integer)
  end

  def changeset(%Totp{} = totp, attrs) do
    totp
    |> cast(attrs, [:subject_id, :secret_key, :scratch_codes])
    |> validate_required([:subject_id, :secret_key, :scratch_codes])
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
      |> Base.decode64()
      |> AES.decrypt()
      |> String.split(";")

    {secret_key, scratch_codes} =
      {Base.decode32(key), codes |> String.split(",") |> Enum.map(fn c -> Integer.parse(c) end)}

    %Totp{
      id: p.id,
      subject_id: p.subject_id,
      secret_key: secret_key,
      scratch_codes: scratch_codes,
      seq: p.seq
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
      scratch_codes: scratch_codes |> String.split(",") |> Enum.map(&String.to_integer/1)
    }
  end

  def uri(secret_key, issuer, uid) do
    secret = Base.encode32(secret_key)

    "otpauth://totp/#{issuer}:#{uid}?secret=#{secret}&issuer=#{issuer}&algorithm=sha1&digits=6&period=30"
  end
end
