defmodule Votr.Api.SubjectsController do
  use VotrWeb, :controller
  use Timex
  require Logger
  alias Votr.Identity.Email
  alias Votr.Identity.Token
  alias Votr.Identity.Password
  alias Votr.HashId

  @doc """
  register for a new account, or reset password
  """
  def create(conn, %{"username" => username, "password" => password}) do
    # TODO add random wait time to avoid timing attacks

    with {:ok, email} <- Email.select_by_address(username) do
      # account exists, reset password
      {:ok, token} = Token.insert(email.subject_id, "password", Password.hash(password))

      # TODO send the user an email
      Logger.debug "Token ID #{HashId.encode(token.id)}"
    else
      {:error, :not_found} ->
        # account doesn't exist, create it
        {:ok, token} = Token.insert_account(username, password)

        # TODO send the user an email
        Logger.debug "Token ID #{HashId.encode(token.id)}"
    end

    # always send a 200 to avoid user enumeration attacks
    conn
    |> put_status(200)
    |> json(%{success: true})
  end
end
