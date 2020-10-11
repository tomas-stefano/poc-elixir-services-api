defmodule MetadataApiWeb.ServiceController do
  use MetadataApiWeb, :controller

  alias MetadataApi.ServiceRepo
  alias MetadataApi.MetadataRepo
  alias MetadataApi.ServiceRepo.Service

  action_fallback MetadataApiWeb.FallbackController

#  def index(conn, _params) do
#    services = ServiceRepo.list_services()
#    render(conn, "index.json", services: services)
#  end

  def create(conn, metadata_params) do
    with {:ok, %Service{} = service} <- ServiceRepo.create_service(metadata_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.service_path(conn, :show, service))
      |> render("service.json", service: service, metadata: List.last(service.metadata))
    end
  end

  def show(conn, %{"id" => id}) do
    service = ServiceRepo.get_service!(id)
    metadata = ServiceRepo.last_metadata!(id)
    render(conn, "service.json", service: service, metadata: metadata)
  end

  def update(conn, service_params) do
    service = ServiceRepo.get_service!(service_params["id"])

    with {:ok, %Service{} = service} <- ServiceRepo.update_service(service, service_params) do
      metadata = ServiceRepo.last_metadata!(service.id)
      render(conn, "service.json", service: service, metadata: metadata)
    end
  end

  def versions(conn, %{"service_id" => id}) do
    service = ServiceRepo.get_service!(id)
    metadata = MetadataRepo.all_versions(service)

    render(conn, "versions.json", service: service, metadata: metadata)
  end
end
