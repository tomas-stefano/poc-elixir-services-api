defmodule HealthCheck do
  use Plug.Router

  get "/health_check" do
    send_resp(conn, 200, "Server is up!")
  end
end
