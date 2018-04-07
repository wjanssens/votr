defmodule Votr.Identity.DateOfBirth do
  @moduledoc """
  Date of birth may be used as a form of identity confirmation during voting.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.DateOfBirth
  alias Votr.Identity.Principal

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:date, :date)
    field(:subject_id, :integer)
  end

  def changeset(%DateOfBirth{} = dob, attrs) do
    dob
    |> cast(attrs, [:subject_id, :date])
    |> validate_required([:subject_id, :date])
    |> Map.update(:version, 0, &(&1 + 1))
    |> to_principal
  end

  def to_principal(%DateOfBirth{} = dob) do
    %Principal{
      id: dob.id,
      subject_id: dob.subject_id,
      kind: "dob",
      seq: nil,
      hash: nil,
      value:
        dob.date
        |> Date.to_iso8601()
        |> AES.encrypt()
        |> Base.encode64()
    }
  end

  def from_principal(%Principal{} = p) do
    date =
      p.value
      |> Base.decode64()
      |> AES.decrypt()
      |> Date.from_iso8601()

    %DateOfBirth{
      id: p.id,
      subject_id: p.subject_id,
      dob: date,
      seq: nil
    }
  end
end
