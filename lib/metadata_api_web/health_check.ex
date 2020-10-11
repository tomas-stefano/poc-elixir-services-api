defmodule MetadataApiWeb.HealthCheck do
  import Plug.Conn

  def init(_) do
  end

  def call(%Plug.Conn{} = conn, opts) do
    send_resp(conn, 200, "Up!")
  end
end
