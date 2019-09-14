defmodule VotrWeb.Router do
  use VotrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SetLocale, gettext: VotrWeb.Gettext, default_locale: "en", cookie_key: "votr_locale"
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Votr.Plug.RateLimit, [max_requests: 5, interval_seconds: 60]
    #plug :protect_from_forgery
  end

  pipeline :api_authenticated do
    plug :accepts, ["json"]
    plug Votr.Plug.ApiAuthenticate
    #plug :protect_from_forgery
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

    # TODO don't really want this endpoint rate-limited, how best to address this?
    # could put the rate limit plug into the other three controllers instead of in the pipeline?
    resources("/voters/:voter_id/ballots", VoteController, only: [:show, :update])
    resources("/login", LoginController, only: [:create])
    resources("/activate", ActivateController, only: [:create])
    resources("/subjects", SubjectsController, only: [:create])
  end

  scope "/api/admin", Votr.Api do
    pipe_through(:api_authenticated)

    resources("/wards", WardsController, only: [:create, :update, :delete])
    resources("/wards/:ward_id/wards", WardsController, only: [:index])
    resources("/wards/:ward_id/voters", VotersController, only: [:index])
    resources("/wards/:ward_id/ballots", BallotsController, only: [:index])
    resources("/ballots", BallotsController, only: [:create, :update, :delete])
    resources("/ballots/:ballot_id/candidates", CandidatesController, only: [:index])
    resources("/ballots/:ballot_id/votes", BallotVotesController, only: [:index])
    resources("/ballots/:ballot_id/results", BallotResultsController, only: [:index])
    resources("/voters", VoterController, only: [:create, :update, :delete])
    resources("/candidates", CandidatesController, only: [:create, :update, :delete])
    resources("/subjects/:subject_id/principals", PrincipalsController, only: [:index])
    resources("/principals", PrincipalController, only: [:create, :update, :delete])
    resources("/profiles", ProfileController, only: [:show, :update])
    resources("/totp", TotpController, only: [:create, :update, :delete])
  end
end
