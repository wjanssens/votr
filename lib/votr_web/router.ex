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

    # for logging in, resetting passwords, setting up mfa
    resources("/credentials", LoginController, only: [:create, :update])

    # listing, creating, and deleting subjects (accounts)
    resources("/subjects", SubjectsController, only: [:create])
    resources("/subjects/:id", SubjectController, only: [:delete])

    # for maintaining subject principals
    resources("/principals", PrincipalsController, only: [:index, :create])
    resources("/principals/:id", PrincipalController, only: [:update, :delete])

    # for election officials to configure an election
    resources("/wards", WardsController, only: [:index, :create])
    resources("/wards/:id", WardController, only: [:show, :update, :delete])
    resources("/wards/:id/ballots", WardController, only: [:index, :create])
    resources("/wards/:id/wards", WardController, only: [:index, :create])
    resources("/ballots/:id", BallotController, only: [:show, :update, :delete])
    resources("/ballots/:id/candidates", BallotController, only: [:index, :create])
    resources("/candidates/:id", CandidateController, only: [:show, :update, :delete])

    # for retrieving ballots and submitting votes
    resources("/voters/:id", VoteController, only: [:show, :update])

    # list all of the votes for a ballot
    resources("/ballots/:id/votes", BallotVotesController, only: [:index])
    resources("/ballots/:id/result", BallotResultController, only: [:index])
  end
end
