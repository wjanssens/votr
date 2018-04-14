defmodule VotrWeb.Router do
  use VotrWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", VotrWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/api", Votr.Api do
    pipe_through(:api)

    resources("/wards", WardsController, only: [:index, :create])
    resources("/wards/:id", WardController, only: [:update, :delete])
    resources("/wards/:id/ballots", BallotsController, only: [:index, :create])
    resources("/wards/:id/voters", VotersController, only: [:index, :create, :update])
    resources("/ballots/:id", BallotController, only: [:update, :delete])
    resources("/ballots/:id/candidates", CandidatesController, only: [:index, :create])
    resources("/ballots/:id/votes", BallotVotesController, only: [:index])
    resources("/ballots/:id/result", BallotResultController, only: [:index])
    resources("/candidates/:id", CandidateController, only: [:update, :delete])
    resources("/voters/:id", VoterController, only: [:update, :delete])
    resources("/voters/:id/ballots", VoteController, only: [:show, :update])
    resources("/res/:id", ResourcesController, only: [:index])
    resources("/res/:id/:key/:tag", ResourceController, only: [:update, :delete])
    resources("/token", TokenController, only: [:create])
    resources("/subjects", SubjectsController, only: [:create])
    resources("/subjects/:id/principals", PrincipalsController, only: [:index, :create])
    resources("/principals/:id", PrincipalController, only: [:update, :delete])
    resources("/activate/:id", ActivateController, only: [:show, :update])
  end
end
