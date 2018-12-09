defmodule VotrWeb.I18nController do
  use VotrWeb, :controller

  def index(conn, _params) do

    conn
    |> json([
      %{ :id => "Next", :value => gettext("Next") },
      %{ :id => "Voter Login", :value => gettext("Voter Login") },
      %{ :id => "Officials", :value => gettext("Officials") },
      %{ :id => "Access Code", :value => gettext("Access Code") }
    ])
  end
end
