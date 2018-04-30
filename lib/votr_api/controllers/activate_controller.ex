defmodule Votr.Api.ActivateController do
  use VotrWeb, :controller
  alias Votr.Identity.Email
  alias Votr.Identity.Token
  alias Votr.Identity.Principal
  alias Votr.HashId

  def show(conn, %{"id" => id}) do
    with {:ok, token} <- Token.select(HashId.decode(id)),
         {:ok, email} <- Email.select_by_id(String.to_integer(token.value)),
         _ <- Map.merge(
                email,
                %{valid: true}
              )
              |> Email.update(),
         _ <- Principal.delete(token.id, token.version) do
      conn
      |> put_status(200)
      |> json(%{success: true})
    else
      _ ->
        conn
        |> put_status(404)
        |> json(%{success: false, error: "not_found"})
    end
  end

end

