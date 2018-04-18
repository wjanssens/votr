# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :votr,
  ecto_repos: [Votr.Repo]

# Ecto configuration
config :votr, Votr.Repo,
  migration_primary_key: [id: :id, type: :bigint],
  migration_timestamps: [type: :utc_datetime]

# keys to encrypt data with
# only one key is used for encryption
# the others are used to decrypt data previously encrypted with that key
config :votr, Votr.AES,
  keys: %{
    <<1>> => "e62cf85ce0ff3a1f9f388e9361bd87ad" |> Base.decode16,
    <<2>> => "4803491d183d2a5cc6f32120ce8a5c1c" |> Base.decode16,
    <<3>> => "e70870de242a6b4f11a575a79ce0cc0d" |> Base.decode16,
    <<4>> => "1a56fac07bb700043396b12d0beef709" |> Base.decode16
  },
  default_key_id: <<1>>

config :votr, Votr.Identity.Password,
  algorithm: :bcrypt

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
