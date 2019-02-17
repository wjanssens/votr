defmodule Votr.Api.LoginController do
  use VotrWeb, :controller
  alias Votr.Identity.Email
  alias Votr.Identity.Password
  alias Votr.Identity.Controls
  alias Votr.Identity.Totp
  alias Votr.JWT
  alias Votr.HashId

  @moduledoc """
  This controller is responsible for trading credentials for a token
  """

  @doc """
  log in with credentials to receive a bearer token
  """
  def create(
        conn,
        %{"client_id" => client_id, "grant_type" => grant_type, "username" => username, "password" => password}
      ) do
    # TODO add random wait time to avoid timing attacks
    # TODO make the cookies secure only

    case client_id do
      "votr_admin" ->
        case grant_type do
          "password" ->
            with {:ok, email} <- Email.select_by_address(username),
                 {:ok, _} <- Email.verify(email),
                 {:ok, controls} <- Controls.verify(email.subject_id),
                 {:ok, :valid} <- Password.verify(email.subject_id, password),
                 {:error, :not_found} <- Totp.select_by_subject_id(email.subject_id) do
              jwt = JWT.generate(email.subject_id)

              Controls.update(Map.put(controls, :login_at, DateTime.utc_now()))

              conn
              |> put_status(:ok)
              |> put_resp_cookie("access_token", jwt, http_only: true)
              |> json(
                   %{
                     access_token: jwt,
                     token_type: "Bearer",
                     expires_in: JWT.expires_in()
                   }
                 )
            else
              {:ok, %Totp{} = totp} ->
                # this subject has a TOTP token, so prompt them for it
                # TODO don't send the TOTP token id, instead create a temporary conversation token and send that
                # otherwise the second factor effectively becomes a single factor
                conn
                |> put_status(:unauthorized)
                |> json(%{success: false, error: "mfa_required", token: HashId.encode(totp.id)})
              _ ->
                conn
                |> put_status(:unauthorized)
                |> json(%{success: false, error: "unauthorized"})
            end
          "otp" ->
            # the username is the totp token id
            # the password is the one time password
            # TODO look up the totp token based on a temporary conversation token instead
            with {:ok, totp} <- Totp.select(HashId.decode(username)),
                 {:ok, :valid} <- Totp.verify(password, totp.secret_key) do
              jwt = JWT.generate(totp.subject_id)
              conn
              |> put_status(:ok)
              |> put_resp_cookie("access_token", jwt, http_only: true)
              |> json(
                   %{
                     access_token: jwt,
                     token_type: "Bearer",
                     expires_in: JWT.expires_in()
                   }
                 )
            else
              _ -> conn
                   |> put_status(:unauthorized)
                   |> json(%{success: false, error: "unauthorized"})
            end
          _ ->
            conn
            |> put_status(:unauthorized)
            |> json(%{success: false, error: "unauthorized"})
        end
      "votr_voter" ->
        case grant_type do
          "cr" ->
            conn
            |> put_status(:unauthorized)
            |> json(%{success: false, error: "unauthorized"})
          _ ->
            conn
            |> put_status(:unauthorized)
            |> json(%{success: false, error: "unauthorized"})
        end
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{success: false, error: "unauthorized"})
    end
  end
end
