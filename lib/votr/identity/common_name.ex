defmodule Votr.Identity.CommonName do
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.CommonName
  alias Votr.Identity.Principal
  alias Votr.AES

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:name, :string)
  end

  def changeset(%CommonName{} = cn, attrs) do
    cn
    |> cast(attrs, [:subject_id, :username])
    |> validate_required([:subject_id, :name])
    |> Map.update(:version, 0, &(&1 + 1))
    |> to_principal
  end

  def to_principal(%CommonName{} = cn) do
    %Principal{
      id: cn.id,
      kind: "common_name",
      seq: nil,
      subject_id: cn.subject_id,
      version: cn.version,
      hash: :crypto.hash(:sha256, cn.name)
            |> Base.encode64,
      value:
        cn.name
        |> AES.encrypt()
        |> Base.encode64()
    }
  end

  def from_principal(%Principal{} = p) do
    name =
      p.value
      |> Base.decode64()
      |> AES.decrypt()

    %CommonName{
      id: p.id,
      subject_id: p.subject_id,
      version: p.version,
      name: name
    }
  end
end
