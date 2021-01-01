# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :live_groceries,
  ecto_repos: [LiveGroceries.Repo]

# Configures the endpoint
config :live_groceries, LiveGroceriesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2Y6T2OKI+cx57TY3LpQBOVT0y1wYIGCOtZeo/OyyQw79o6ISnett+xo7RTLQCkDP",
  render_errors: [view: LiveGroceriesWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveGroceries.PubSub,
  live_view: [signing_salt: "pznUQz39"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

sendgrid_api_key =
  System.get_env("SENDGRID_API_KEY") ||
    raise """
    environment variable SENDGRID_API_KEY is missing.
    """

config :live_groceries, LiveGroceries.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: sendgrid_api_key,
  hackney_opts: [
    recv_timeout: :timer.minutes(1)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
