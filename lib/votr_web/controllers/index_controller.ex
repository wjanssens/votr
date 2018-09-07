defmodule VotrWeb.IndexController do
  use VotrWeb, :controller

  def index(conn, _params) do
    render conn, VotrWeb.PageView, "index.html"
  end
end
