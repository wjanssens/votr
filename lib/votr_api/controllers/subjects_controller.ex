defmodule Votr.Api.SubjectsController do
  use VotrWeb, :controller
  use Timex
  alias Votr.Identity.Subject
  alias Votr.Identity.Email
  alias Votr.Identity.Password
  alias Votr.Identity.Controls
  alias Votr.Identity.Token
  alias Votr.Repo

  # register for a new account
  def create(conn, %{"username" => username, "password" => password}) do
    case Email.select_by_address(username) do
      {:ok, _} ->
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
        case Repo.transaction(
               fn ->
                 with {:ok, subject} = Subject.insert(username),
                      {:ok, email} = Email.insert(subject.id, username),
                      {:ok, _} = Password.insert(subject.id, Password.hash(password)),
                      {:ok, _} = Controls.insert(%Controls{subject_id: subject.id, failures: 0}),
                      token_expiry = Timex.now()
                                     |> Timex.add(Timex.Duration.from_days(2))
                                     |> Timex.to_datetime(),
                      {:ok, _} = Token.insert(subject.id, "email", Integer.to_string(email.id), token_expiry) do
                   # TODO send the user an email
                 end
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
end
