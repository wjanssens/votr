defmodule Votr.Accounts.DateOfBirth do
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Accounts.DateOfBirth
  alias Votr.Accounts.Principal

  embedded_schema do
    field(:dob, :string)
    field(:subject_id, :integer)
  end

  def changeset(%DateOfBirth{} = dob, attrs) do
    dob
    |> cast(attrs, [:subject_id, :dob])
    |> validate_required([:subject_id, :dob])
  end

  def to_principal(%DateOfBirth{} = dob) do
    %Principal{
      id: dob.id,
      subject_id: dob.subject_id,
      kind: "dob",
      seq: nil,
      hash: nil,
      data:
        dob.dob
        |> Date.to_iso8601(format)
        |> AES.encrypt()
        |> Base.encode64()
    }
  end

  def from_principal(%Principal{} = p) do
    dob =
      p.data
      |> Base.decode64()
      |> AES.decrypt()
      |> Date.from_iso8601()

    %DateOfBirth{
      id: p.id,
      subject_id: p.subject_id,
      dob: dob,
      seq: nil
    }
  end
end
