defmodule Votr.Mixfile do
  use Mix.Project

  def project do
    [
      app: :votr,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Votr.Application, []},
      extra_applications: [:logger, :runtime_tools, :timex, :set_locale]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.1.5", only: :dev},
      #{:gettext, "~> 0.16"},
      {:set_locale, "~> 0.2.4"},
      {:plug_cowboy, "~> 1.0"},
      {:distillery, "~> 1.5.2"},
      {:flexid, "~> 0.1.1"},
      {:hashids, "~> 2.0.4"},
      {:timex, "~> 3.1"},
      {:argon2_elixir, "~> 1.2"},
      {:bcrypt_elixir, "~> 1.0.6"},
      {:pbkdf2_elixir, "~> 0.12.3"},
      {:json_web_token, "~> 0.2.10"},
      {:ex_rated, "~> 1.3.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
