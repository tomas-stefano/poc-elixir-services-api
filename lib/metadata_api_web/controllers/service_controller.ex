defmodule MetadataApiWeb.ServiceController do
  use MetadataApiWeb, :controller

  alias MetadataApi.ServiceRepo
  alias MetadataApi.ServiceRepo.Service

  action_fallback MetadataApiWeb.FallbackController

#  def index(conn, _params) do
#    services = ServiceRepo.list_services()
#    render(conn, "index.json", services: services)
#  end

  def create(conn, %{"metadata" => metadata}) do
    with {:ok, %Service{} = service} <- ServiceRepo.create_service(metadata) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.service_path(conn, :show, service))
      |> render("show.json", service: service)
    end
  end

#  def show(conn, %{"id" => id}) do
#    service = ServiceRepo.get_service!(id)
#    render(conn, "show.json", service: service)
#  end
#
#  def update(conn, %{"id" => id, "service" => service_params}) do
#    service = ServiceRepo.get_service!(id)
#
#    with {:ok, %Service{} = service} <- ServiceRepo.update_service(service, service_params) do
#      render(conn, "show.json", service: service)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    service = ServiceRepo.get_service!(id)
#
#    with {:ok, %Service{}} <- ServiceRepo.delete_service(service) do
#      send_resp(conn, :no_content, "")
#    end
#  end
end
