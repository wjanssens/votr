defmodule VotrWeb.I18nController do
  use VotrWeb, :controller

  def index(conn, _params) do

    conn
    |> json(%{
      :foo => gettext("Foo"),
      :bar => gettext("Bar")
    })
  end
end
