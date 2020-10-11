defmodule MetadataApiWeb.ServiceControllerTest do
  use MetadataApiWeb.ConnCase

#  alias MetadataApi.ServiceRepo
#  alias MetadataApi.ServiceRepo.Service

  @create_attrs %{
    metadata: %{
      service_name: "Formatron",
      created_by: "1234",
      updated_by: "1234",
      pages: [
        %{ url: "/" }
      ]
    }
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "POST /services" do
    test "when passing the metadata", %{conn: conn} do
      conn = post(conn, Routes.service_path(conn, :create), @create_attrs)
      service_name = @create_attrs[:metadata][:service_name]
      created_by = @create_attrs[:metadata][:created_by]
      updated_by = @create_attrs[:metadata][:updated_by]

      assert %{
        "metadata" => %{
          "service_id" => id,
          "service_name" => service_name,
          "created_by" => created_by,
          "updated_by" => updated_by,
          "pages" => [%{"url" => "/" }]
        }
      } = json_response(conn, 201)
    end

    test "when not passing any metadata", %{conn: conn} do
      conn = post(conn, Routes.service_path(conn, :create), %{metadata: %{}})

      assert %{
        "message" => %{
          "service_name" => ["can't be blank"]
        }
      }  = json_response(conn, 422)
    end

    test "when not passing anything", %{conn: conn} do
      conn = post(conn, Routes.service_path(conn, :create), %{})

      assert %{
        "message" => %{
          "service_name" => ["can't be blank"],
          "metadata" => ["can't be blank"]
        }
      } = json_response(conn, 422)
    end
  end

#  @update_attrs %{
#    name: "some updated name"
#  }
#  @invalid_attrs %{name: nil}
#
#  def fixture(:service) do
#    {:ok, service} = ServiceRepo.create_service(@create_attrs)
#    service
#  end
#
#  setup %{conn: conn} do
#    {:ok, conn: put_req_header(conn, "accept", "application/json")}
#  end
#
#  describe "index" do
#    test "lists all services", %{conn: conn} do
#      conn = get(conn, Routes.service_path(conn, :index))
#      assert json_response(conn, 200)["data"] == []
#    end
#  end
#
#  describe "create service" do
#    test "renders service when data is valid", %{conn: conn} do
#      conn = post(conn, Routes.service_path(conn, :create), service: @create_attrs)
#      assert %{"id" => id} = json_response(conn, 201)["data"]
#
#      conn = get(conn, Routes.service_path(conn, :show, id))
#
#      assert %{
#               "id" => id,
#               "name" => "some name"
#             } = json_response(conn, 200)["data"]
#    end
#
#    test "renders errors when data is invalid", %{conn: conn} do
#      conn = post(conn, Routes.service_path(conn, :create), service: @invalid_attrs)
#      assert json_response(conn, 422)["errors"] != %{}
#    end
#  end
#
#  describe "update service" do
#    setup [:create_service]
#
#    test "renders service when data is valid", %{conn: conn, service: %Service{id: id} = service} do
#      conn = put(conn, Routes.service_path(conn, :update, service), service: @update_attrs)
#      assert %{"id" => ^id} = json_response(conn, 200)["data"]
#
#      conn = get(conn, Routes.service_path(conn, :show, id))
#
#      assert %{
#               "id" => id,
#               "name" => "some updated name"
#             } = json_response(conn, 200)["data"]
#    end
#
#    test "renders errors when data is invalid", %{conn: conn, service: service} do
#      conn = put(conn, Routes.service_path(conn, :update, service), service: @invalid_attrs)
#      assert json_response(conn, 422)["errors"] != %{}
#    end
#  end
#
#  describe "delete service" do
#    setup [:create_service]
#
#    test "deletes chosen service", %{conn: conn, service: service} do
#      conn = delete(conn, Routes.service_path(conn, :delete, service))
#      assert response(conn, 204)
#
#      assert_error_sent 404, fn ->
#        get(conn, Routes.service_path(conn, :show, service))
#      end
#    end
#  end
#
#  defp create_service(_) do
#    service = fixture(:service)
#    %{service: service}
#  end
end
