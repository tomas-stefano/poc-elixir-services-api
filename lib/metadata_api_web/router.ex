defmodule MetadataApiWeb.Router do
  use MetadataApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MetadataApiWeb do
    pipe_through :api

    resources "/services", ServiceController, only: [:create, :update, :show] do
      get "/versions", ServiceController, :versions, as: :versions
      get "/versions/:version_id", ServiceController, :version, as: :version
    end
  end

  scope "/health_check", log: false do
    forward "/", MetadataApiWeb.HealthCheck
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: MetadataApiWeb.Telemetry
    end
  end
end
