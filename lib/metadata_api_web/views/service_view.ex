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

  def render("versions.json", %{service: service, metadata: metadata}) do
    versions = Enum.map(metadata, fn(version) ->
      %{
        "version_id" => version[:version_id],
        "version_number" => version[:version_number],
        "created_at" => NaiveDateTime.to_iso8601(version[:inserted_at])
      }
    end)

    %{
      "service_id" => service.id,
      "service_name" => service.service_name,
      "versions" => versions
    }
  end

  def render("version.json", %{metadata: metadata}) do
    Map.merge(
      metadata.data,
      %{
        "service_name" => metadata.service.service_name,
        "service_id" => metadata.service_id,
        "version_id" => metadata.version_id,
        "version_number" => metadata.version_number,
        "created_at" => NaiveDateTime.to_iso8601(metadata.inserted_at),
        "updated_at" => NaiveDateTime.to_iso8601(metadata.updated_at),
        "created_by" => metadata.created_by,
        "updated_by" => metadata.updated_by
      }
    )
  end
end
