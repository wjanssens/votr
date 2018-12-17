defmodule Votr.Api.TotpController do
  use VotrWeb, :controller
  alias Votr.Identity.Totp
  alias Votr.Identity.Principal

  @moduledoc """
  This controller is responsible for enrolling and un-enrolling for TOTP
  """

  def create(conn) do
    subject_id = conn.assigns[:subject_id]

    with {:ok, _} <- Totp.insert(Totp.new(subject_id)) do
      conn
      |> put_status(200)
      |> json(%{success: true})
    end
  end

  def update(conn, %{"id" => _, "code" => code}) do
    subject_id = conn.assigns[:subject_id]

    with {:ok, totp} <- Totp.select_by_subject_id(subject_id),
         {:ok, :valid} <- Totp.verify(totp, code),
         {:ok, _} <- Totp.update(Map.put(totp, :state, :valid)) do
      conn
      |> put_status(200)
      |> json(%{success: true})
    end
  end

  def delete(conn, %{"id" => id}) do
    # TODO verify that the subject owns the principal

    subject_id = conn.assigns[:subject_id]

    with {:ok, _} <- Principal.delete(id) do
      conn
      |> put_status(200)
      |> json(%{success: true})
    end
  end

end

