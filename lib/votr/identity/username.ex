defmodule Votr.Identity.Username do
  @moduledoc """
  Usernames are used by election officials to log in.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Identity.Username
  alias Votr.Identity.Principal

  embedded_schema do
    field(:username, :string)
    field(:subject_id, :integer)
  end

  def changeset(%Username{} = username, attrs) do
    username
    |> cast(attrs, [:subject_id, :username])
    |> validate_required([:subject_id, :username])
  end

  def to_principal(%Username{} = username) do
    %Principal{
      id: username.id,
      kind: "username",
      seq: nil,
      subject_id: username.subject_id,
      hash: :crypto.hash(:sha512, username.username),
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
      username: username,
      seq: p.seq
    }
  end
end
