defmodule Votr.Api.TokenController do
  use VotrWeb, :controller
  alias Votr.Identity.Email
  alias Votr.Identity.Password
  alias Votr.Identity.Totp
  alias Votr.JWT
  require OK

  def create(conn, %{"grant_type" => grant_type, "username" => username, "password" => password}) do
    case grant_type do
      "password" ->
        OK.try do
          email <- Email.select_by_address(username)
          expected <- Password.select_by_subject_id(email.subject_id)
        after
          case Password.verify(password, expected.hash) do
            true ->
              # valid password
              case Totp.select_by_subject_id(email.subject_id) do
                {:ok, totp} ->
                  # TODO is it OK to give the client the token ID?
                  conn
                  |> put_status(401)
                  |> json(%{success: false, error: "mfa_required", token: HashId.encode(totp.id)})
                {:error, :not_found} ->
                  jwt = JWT.generate(email.subject_id)

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

              end

            false ->
              # invalid password
              conn
              |> put_status(401)
              |> json(%{success: false, error: "unauthorized"})
          end
        rescue
          # email and/or password were not found
          _ ->
            conn
            |> put_status(401)
            |> json(%{success: false, error: "unauthorized"})
        end

      "otp" ->
        # the username is the totp token id
        # the password is the one time password
        case Totp.select(HashId.decode(username)) do
          {:ok, totp} ->
            case Totp.verify(password, totp.secret_key) do
              true ->
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
              false ->
                conn
                |> put_status(401)
                |> json(%{success: false, error: "unauthorized"})
            end
          {:error, _} ->
            # the token wasn't found
            conn
            |> put_status(401)
            |> json(%{success: false, error: "unauthorized"})
        end
    end
  end
end
