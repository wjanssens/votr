defmodule VotrWeb.PublicController do
  use VotrWeb, :controller

  def index(conn, _params) do
    render conn, VotrWeb.PageView, "public.html"
  end
end
