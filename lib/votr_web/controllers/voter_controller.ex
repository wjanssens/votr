defmodule VotrWeb.VoterController do
  use VotrWeb, :controller

  def index(conn, _params) do
    render conn, VotrWeb.PageView, "voter.html"
  end
end
