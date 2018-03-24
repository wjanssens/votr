# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :votr,
  ecto_repos: [Votr.Repo]

# Configures the endpoint
config :votr, VotrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9uZOJES06ibtERm6f4IReez6E8VyZk4LoL2pQbHYm7Ni/KuepJnJRtTWGfmFy4jJ",
  render_errors: [view: VotrWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Votr.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
