defmodule Votr.Identity.Username do
  @moduledoc """
  Usernames are used by election officials to log in.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.Username
  alias Votr.Identity.Principal
  alias Votr.AES

  embedded_schema do
    field(:subject_id, :integer)
    field(:version, :integer)
    field(:username, :string)
  end

  def changeset(%Username{} = username, attrs) do
    username
    |> cast(attrs, [:subject_id, :username])
    |> validate_required([:subject_id, :username])
    |> Map.update(:version, 0, &(&1 + 1))
    |> to_principal
  end

  def to_principal(%Username{} = username) do
    %Principal{
      id: username.id,
      kind: "username",
      seq: nil,
      subject_id: username.subject_id,
      version: username.version,
      hash: :crypto.hash(:sha256, username.username)
            |> Base.encode64,
      value:
        username.username
        |> AES.encrypt()
        |> Base.encode64()
    }
  end

  def from_principal(%Principal{} = p) do
    username =
      p.value
      |> Base.decode64()
      |> AES.decrypt()

    %Username{
      id: p.id,
      subject_id: p.subject_id,
      version: p.version,
      username: username
    }
  end
end
