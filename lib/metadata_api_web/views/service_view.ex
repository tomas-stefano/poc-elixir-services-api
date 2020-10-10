defmodule MetadataApiWeb.ServiceView do
  use MetadataApiWeb, :view
  alias MetadataApiWeb.ServiceView

  def render("index.json", %{services: services}) do
    render_many(services, ServiceView, "service.json")
  end

  def render("show.json", %{service: service}) do
    render_one(service, ServiceView, "service.json")
  end

  def render("service.json", %{service: service}) do
    %{
      metadata: %{
        service_id: service.id,
        service_name: service.service_name
      }
    }
  end
end
