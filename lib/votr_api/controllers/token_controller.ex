defmodule Votr.Api.TokenController do
  use VotrWeb, :controller
  alias Votr.Identity.Email
  alias Votr.Identity.Password
  alias Votr.Identity.Controls
  alias Votr.Identity.Totp
  alias Votr.JWT
  alias Votr.HashId

  def create(conn, %{"grant_type" => grant_type, "username" => username, "password" => password}) do
    case grant_type do
      "password" ->
        with {:ok, email} <- Email.select_by_address(username),
             "valid" <- email.state,
             {:ok, controls} <- Controls.verify(email.subject_id),
             {:ok, :valid} <- Password.verify(email.subject_id, password),
             {:error, :not_found} <- Totp.select_by_subject_id(email.subject_id) do
          jwt = JWT.generate(email.subject_id)

          Controls.update(Map.put(controls, :login_at, DateTime.utc_now()))

          conn
          |> put_status(200)
          |> put_resp_cookie("access_token", jwt, http_only: true, secure: true)
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
            # TODO is it OK to give the client the token ID?
            conn
            |> put_status(401)
            |> json(%{success: false, error: "mfa_required", token: HashId.encode(totp.id)})
          _ ->
            conn
            |> put_status(401)
            |> json(%{success: false, error: "unauthorized"})
        end
      "otp" ->
        # the username is the totp token id
        # the password is the one time password
        with {:ok, totp} <- Totp.select(HashId.decode(username)),
             {:ok, :valid} <- Totp.verify(password, totp.secret_key) do
          jwt = JWT.generate(totp.subject_id)
          conn
          |> put_status(200)
          |> put_resp_cookie("access_token", jwt, http_only: true, secure: true)
          |> json(
               %{
                 access_token: jwt,
                 token_type: "Bearer",
                 expires_in: JWT.expires_in()
               }
             )
        else
          _ ->
            conn
            |> put_status(401)
            |> json(%{success: false, error: "unauthorized"})
        end
    end
  end
end
