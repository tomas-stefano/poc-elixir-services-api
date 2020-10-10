defmodule MetadataApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      MetadataApi.Repo,
      # Start the Telemetry supervisor
      MetadataApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MetadataApi.PubSub},
      # Start the Endpoint (http/https)
      MetadataApiWeb.Endpoint
      # Start a worker by calling: MetadataApi.Worker.start_link(arg)
      # {MetadataApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MetadataApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MetadataApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
