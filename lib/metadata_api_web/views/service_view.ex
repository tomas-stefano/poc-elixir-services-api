defmodule MetadataApiWeb.ServiceView do
  use MetadataApiWeb, :view
  alias MetadataApiWeb.ServiceView

  def render("index.json", %{services: services}) do
    render_many(services, ServiceView, "service.json")
  end

  def render("service.json", %{service: service, metadata: metadata}) do
    basic_metadata = %{
      "metadata" => %{
        "service_id" => service.id,
        "service_name" => service.service_name
      }
    }
    %{ metadata: Map.merge(metadata.data, basic_metadata["metadata"]) }
  end
end
