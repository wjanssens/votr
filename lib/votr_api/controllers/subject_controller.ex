import Ecto.Query

defmodule Votr.Api.SubjectController do
  use VotrWeb, :controller
  alias Votr.Identity.Subject

  def index(conn, _params) do
    json(conn, Repo.all(from(s in Subject, select: s.id)))
  end

  # register for a new account
  def create(conn, _params) do
  end
end
