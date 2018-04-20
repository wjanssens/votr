import Ecto.Query

defmodule Votr.Api.SubjectsController do
  use VotrWeb, :controller
  use Timex
  alias Votr.Identity.Subject
  alias Votr.Identity.Email
  alias Votr.Identity.Password
  alias Votr.Identity.Token
  alias Votr.Repo

  def show(conn, %{"key" => key}) do
    cond Token.select_using_key(key) do
      {:ok, token} ->
        cond Email.select_by_id(String.to_integer(token.value)) do
          {:ok, email} ->
            Map.merge(
              email,
              %{valid: true}
            )
            |> Email.update()

            conn
            |> put_status(200)
            |> json(%{success: true})

          {:error, _} ->
            conn
            |> put_status(409)
            |> json(%{success: false, error: "conflict"})
        end

      {:error, _} ->
        conn
        |> put_status(404)
        |> json(
             %{
               success: false,
               error: "not_found",
               message: "An account activation token with this key was not found."
             }
           )


    end
  end
end
