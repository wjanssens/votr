defmodule Votr.Identity.Token do
  @moduledoc """
  Tokens are temporary values used to identify long running conversations
  The key is a random value.
  The usage is how the key is to be used
  Supported usages are:
  - "account": for new account creation
  - "phone": for phone number sms verification
  - "email": for additional email address verification
  - "password": for password reset
  - "totp": for totp enrollment and challenge
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Votr.Identity.Token
  alias Votr.Identity.Password
  alias Votr.Identity.DN
  alias Votr.AES
  alias Votr.Repo

  @primary_key {:id, :integer, autogenerate: false}
  @timestamps_opts [type: :utc_datetime, usec: true]
  schema "token" do
    field(:subject_id, :integer)
    field(:usage, :string)
    field(:value, :string)
    field(:expires_at, :utc_datetime)
    timestamps()
  end

  def select(id) do
    case Repo.get(Token, id) do
      nil -> {:error, :not_found}
      t -> {:ok, Map.update!(t, :value, &(&1 |> Base.decode64!() |> AES.decrypt()))}
    end
  end

  @doc """
  used for email, phone, and password reset
  """
  def insert(subject_id, usage, value, hours \\ 48) do
    shard = FlexId.extract_partition(:id_generator, subject_id)
    id = FlexId.generate(:id_generator, shard)

    expires_at = Timex.now()
                 |> Timex.add(Timex.Duration.from_hours(hours))
                 |> Timex.to_datetime()

    value = value
            |> AES.encrypt()
            |> Base.encode64()

    case %Token{
           id: id,
           subject_id: subject_id,
           usage: usage,
           value: value,
           expires_at: expires_at
         }
         |> cast(%{}, [:id, :subject_id, :usage, :value, :expires_at])
         |> validate_required([:id, :usage, :value, :expires_at])
         |> Repo.insert() do
      {:ok, t} -> {:ok, t}
      {:error, _} -> {:error, :constraint_violation}
    end
  end

  @doc """
  used for new account creation
  """
  def insert_account(username, password, hours \\ 48) do
    shard = FlexId.make_partition(username)
    id = FlexId.generate(:id_generator, shard)

    IO.puts(DN.to_string(%{"username" => username, "password" => Password.hash(password)}))
    value = DN.to_string(%{"username" => username, "password" => Password.hash(password)})
            |> AES.encrypt()
            |> Base.encode64()

    expires_at = Timex.now()
                 |> Timex.add(Timex.Duration.from_hours(hours))
                 |> Timex.to_datetime()

    case %Token{
           id: id,
           usage: "account",
           value: value,
           expires_at: expires_at
         }
         |> cast(%{}, [:id, :usage, :value, :expires_at])
         |> validate_required([:id, :usage, :value, :expires_at])
         |> Repo.insert() do
      {:ok, t} -> {:ok, t}
      {:error, _} -> {:error, :constraint_violation}
    end
  end

  def delete_expired() do
    from(p in Token)
    |> where([p], p.usage == "token" and p.expires_at < fragment("current_timestamp"))
    |> Repo.delete_all
  end

  def delete(id) do
    case from(Token)
         |> where([id: ^id])
         |> Repo.delete_all
      do
      {0, _} -> {:error, :not_found}
      {1, _} -> {:ok, nil}
      {_, _} -> {:error, :too_many_affected}
    end
  end

end
