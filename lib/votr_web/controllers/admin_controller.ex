defmodule VotrWeb.AdminController do
  use VotrWeb, :controller

  def index(conn, _params) do
    render conn, VotrWeb.PageView, "admin.html"
  end
end
