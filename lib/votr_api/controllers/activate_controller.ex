defmodule Votr.Api.ActivateController do
  use VotrWeb, :controller
  alias Votr.Identity.Email
  alias Votr.Identity.Token

  def show(conn, %{"key" => key}) do
    case Token.select_using_key(key) do
      {:ok, token} ->
        case Email.select_by_id(String.to_integer(token.value)) do
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
