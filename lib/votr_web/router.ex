defmodule VotrWeb.Router do
  use VotrWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug SetLocale, gettext: VotrWeb.Gettext, default_locale: "en", cookie_key: "votr_locale"
  end

  pipeline :api do
    plug(:accepts, ["json"])
    #plug(:protect_from_forgery)
  end

  pipeline :api_authenticated do
    plug(:accepts, ["json"])
    plug(Votr.Plug.ApiAuthenticate)
    #plug(:protect_from_forgery)
  end

  scope "/", VotrWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", IndexController, :index)
    get("/:locale", IndexController, :index)
    get("/:locale/admin/", AdminController, :index)
    get("/:locale/voter", VoterController, :index)
    get("/:locale/public", PublicController, :index)
    get("/:locale/i18n.json", I18nController, :index)
  end

  scope "/api", Votr.Api do
    pipe_through(:api)

    resources("/voters/:voter_id/ballots", VoteController, only: [:show, :update])
    resources("/login", LoginController, only: [:create])
    resources("/activate", ActivateController, only: [:show])
    resources("/subjects", SubjectsController, only: [:create])
  end

  scope "/api/admin", Votr.Api do
    pipe_through(:api_authenticated)

    resources("/wards", WardsController, only: [:index, :create, :update, :delete])
    resources("/wards/:ward_id/voters", VotersController, only: [:index, :create])
    put("/wards/:id/voters", VotersController, :replace)
    resources("/ballots", BallotController, only: [:update, :delete])
    resources("/ballots/:ballot_id/candidates", CandidatesController, only: [:index, :create])
    resources("/ballots/:ballot_id/votes", BallotVotesController, only: [:index])
    resources("/ballots/:ballot_id/result", BallotResultController, only: [:index])
    resources("/voters", VoterController, only: [:update, :delete])
    resources("/voters/:voter_id/ballots", VoteController, only: [:show, :update])
    resources("/res", ResourcesController, only: [:index])
    resources("/res/:res_id/:key/:tag", ResourceController, only: [:update, :delete])
    resources("/subjects/:subject_id/principals", PrincipalsController, only: [:index, :create])
    resources("/totp", TotpController, only: [:create, :update, :delete])
    resources("/principals", PrincipalController, only: [:update, :delete])
  end
end
