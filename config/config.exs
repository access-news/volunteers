# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :anv,
  ecto_repos: [ANV.Repo]

# Configures the endpoint
config :anv, ANVWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "h9AdaLBz2b+YcS2TOHXYzAmJO/hGFe5xay7aFgBuU2dO4+uUjlbz5pL7i0py32df",
  render_errors: [view: ANVWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ANV.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Google Cloud Platform auth (see `shell.nix` for ENV variable)
config :goth, json: System.get_env("GOOGLE_APPLICATION_CREDENTIALS")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
