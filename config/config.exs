# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :metadata_api,
  ecto_repos: [MetadataApi.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :metadata_api, MetadataApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lGSg+eEIAHUaORrg8uRHHK5UPpTg6v3ELbre0lioGqM7hyXRjvyKSEYsrurxxed8",
  render_errors: [view: MetadataApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: MetadataApi.PubSub,
  live_view: [signing_salt: "R0o1+Slf"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
