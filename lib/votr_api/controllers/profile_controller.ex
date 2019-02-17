defmodule Votr.Api.ProfileController do
  use VotrWeb, :controller
  alias Votr.Identity.Email
  alias Votr.Identity.Password
  alias Votr.Identity.Controls
  alias Votr.Identity.Totp
  alias Votr.JWT
  alias Votr.HashId

  def show(conn, %{"id" => id}) do
    %{
      "email" => "test@example.com",
      "totp" => false
    }
  end

  def update(conn, body) do
    current_password = body["current_password"]
    password = body["password"]
    email = body["email"]


  end
end
