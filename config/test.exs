use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :votr,
       VotrWeb.Endpoint,
       http: [
         port: 4001
       ],
       server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :votr,
       Votr.Repo,
       adapter: Ecto.Adapters.Postgres,
       username: "postgres",
       password: "postgres",
       database: "votr_test",
       hostname: "localhost",
       pool: Ecto.Adapters.SQL.Sandbox

config :argon2_elixir,
       t_cost: 1,
       m_cost: 8

config :bcrypt_elixir, :log_rounds, 4
