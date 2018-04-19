import Ecto.Query

defmodule Votr.Api.SubjectsController do
  use VotrWeb, :controller
  use Timex
  alias Votr.Identity.Subject
  alias Votr.Identity.Email
  alias Votr.Identity.Password
  alias Votr.Identity.Token
  alias Votr.Repo

  def index(conn, _params) do
    json(conn, Repo.all(from(s in Subject, select: s.id)))
  end

  # register for a new account
  def create(conn, %{"username" => username, "password" => password}) do
    case Email.select_by_address(username) do
      {:ok, email} ->
        conn
        |> put_status(409)
        |> json(
             %{
               success: false,
               error: "already_exists",
               message: "A user with this email address already exists."
             }
           )
      {:error, :not_found} ->
        shard = FlexId.make_partition(username)
        subject_id = FlexId.generate(:id_generator, shard)

        case Repo.transaction(
               fn ->
                 %Subject{
                   id: subject_id
                 }
                 |> Repo.insert!()

                 email_id = FlexId.generate(:id_generator, shard)
                 Email.changeset(%Email{},
                   %{
                     id: email_id,
                     subject_id: subject_id,
                     seq: 1,
                     address: username,
                     label: "other",
                     state: "invalid"
                   }
                 )
                 |> Repo.insert!()

                 Password.changeset(%Password{},
                   %{
                     id: FlexId.generate(:id_generator, shard),
                     subject_id: subject_id,
                     password: password
                   }
                 )
                 |> Repo.insert!()

                 Token.changeset(%Token{},
                   %{
                     id: FlexId.generate(:id_generator, shard),
                     subject_id: subject_id,
                     usage: "email",
                     value: email_id,
                     expiry:
                       Timex.now()
                       |> Timex.add(Timex.Duration.from_days(4))
                       |> Timex.to_datetime()
                   }
                 )
                 |> Repo.insert!()
               end
             ) do
          {:ok, _} ->
            conn
            |> put_status(201)
            |> json(%{success: true})
          {:error, _} ->
            conn
            |> put_status(409)
            |> json(%{success: false, error: "conflict"})
        end
    end
  end
