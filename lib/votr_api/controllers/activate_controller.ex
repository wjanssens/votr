defmodule Votr.Api.ActivateController do
  use VotrWeb, :controller
  alias Votr.Identity.Email
  alias Votr.Identity.Password
  alias Votr.Identity.Token
  alias Votr.Identity.Subject
  alias Votr.Identity.Controls
  alias Votr.Identity.Phone
  alias Votr.Identity.DN
  alias Votr.HashId
  alias Votr.JWT
  alias Votr.Repo

  @moduledoc """
  This controller is responsible for handling verification codes
  """

  @doc """
  perform the action associated with an activation code
  * mark an email address as valid
  * mark a phone number as valid
  * update a password
  """
  def show(conn, %{"id" => id}) do
    with {:ok, token} <- Token.select(HashId.decode(id)),
         {:ok, subject_id} <- update_token(token),
         {:ok, _} <- Token.delete(token.id) do

      if is_nil(subject_id) do
        conn
        |> put_status(200)
        |> json(%{success: true})
      else
        jwt = JWT.generate(subject_id)
        conn
        |> put_status(200)
        |> put_resp_cookie("access_token", jwt, http_only: true, secure: true)
        |> json(%{success: true})
      end
    else
      _ ->
        conn
        |> put_status(404)
        |> json(%{success: false, error: "not_found"})
    end
  end

  defp update_token(token) do
    case token.usage do
      "account" -> create_account(token)
      "email" -> update_email(token)
      "password" -> update_password(token)
      "phone" -> update_phone(token)
      "totp" -> update_totp(token)
    end
  end

  defp create_account(token) do
    %{"username" => username, "password" => hash} = DN.from_string(token.value)
    Repo.transaction(
      fn ->
        with {:ok, subject} = Subject.insert(username),
             {:ok, _} = Email.insert(subject.id, username),
             {:ok, _} = Password.insert(subject.id, hash),
             {:ok, _} = Controls.insert(%Controls{subject_id: subject.id, failures: 0}) do
          subject.id
        end
      end
    )
  end

  defp update_email(token) do
    with {:ok, email} <- Email.select_by_id(String.to_integer(token.value)) do
      Map.put(email, :state, :valid)
      |> Email.update()

      {:ok, nil}
    end
  end

  defp update_password(token) do
    with password <- Password.select_by_subject_id(token.subject_id) do
      IO.puts "updating password"
      Map.put(password, :hash, token.value)
      |> Password.update()

      {:ok, token.subject_id}
    end
  end

  defp update_phone(token) do
    with {:ok, phone} <- Phone.select_by_id(token.value) do
      Map.put(phone, :state, :valid)
      |> Phone.update()
    end
  end

  defp update_totp(token) do
    # TODO
  end
end

