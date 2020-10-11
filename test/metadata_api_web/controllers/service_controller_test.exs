import IEx
defmodule MetadataApiWeb.ServiceControllerTest do
  use MetadataApiWeb.ConnCase

  alias MetadataApi.ServiceRepo
  alias MetadataApi.MetadataRepo
  alias MetadataApi.ServiceRepo.Service

  @create_attrs %{
    "metadata" => %{
      "service_name" => "Formatron",
      "created_by" => "1234",
      "updated_by" => "1234",
      "pages" => [
        %{ url: "/" }
      ]
    }
  }
  @update_attrs %{
    "metadata" => %{
      "service_name" => "Formatron",
      "created_by" => "1234",
      "updated_by" => "1234",
      "pages" => [
        %{ url: "/" }
      ],
      "configuration" => %{
        "_type" => "something"
      }
    }
  }
  @invalid_attrs %{ "metadata" => %{}}

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
      assert ServiceRepo.count == 1
      assert MetadataRepo.count == 1

      assert List.first(MetadataRepo.all).service_id == id
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

  describe "GET /services/:id" do
    test "returns the latest metadata", %{conn: conn} do
      service = fixture(:service)

      conn = get(conn, Routes.service_path(conn, :show, service.id))

      assert %{
              "metadata" => %{
                "created_by" => "1234",
                "pages" => [%{"url" => "/"}],
                "service_id" => id,
                "service_name" => "Formatron",
                "updated_by" => "1234"
              }
            } = json_response(conn, 200)
    end
  end

  describe "PUT /services/:id" do
    setup [:create_service]

    test "creates more metadata version", %{conn: conn, service: %Service{id: id} = service} do
      assert ServiceRepo.count == 1
      assert MetadataRepo.count == 1
      conn = put(conn, Routes.service_path(conn, :update, id), @update_attrs)
      assert %{
              "metadata" => %{
                "configuration" => %{"_type" => "something"},
                "created_by" => "1234",
                "pages" => [%{"url" => "/"}],
                "service_id" => id,
                "service_name" => "Formatron",
                "updated_by" => "1234"
              }
            } = json_response(conn, 200)

      assert ServiceRepo.count == 1
      assert MetadataRepo.count == 2
    end

    test "renders errors when data is invalid", %{conn: conn, service: service} do
      assert MetadataRepo.count == 1
      conn = put(conn, Routes.service_path(conn, :update, service.id), @invalid_attrs)
      assert MetadataRepo.count == 1
      assert json_response(conn, 422) == %{
        "message" => %{
          "metadata" => [
            %{},
            %{
              "created_by" => ["can't be blank"],
              "updated_by" => ["can't be blank"]}
          ],
          "service_name" => ["can't be blank"]
        }
      }
    end
  end

  describe "GET /services/:id/versions" do
    test "returns all metadata versions", %{conn: conn} do
      conn = post(conn, Routes.service_path(conn, :create), @create_attrs)
      id = json_response(conn, 201)["metadata"]["service_id"]
      conn = put(conn, Routes.service_path(conn, :update, id), @update_attrs)
      IEx.pry
      assert MetadataRepo.count == 2

      conn = get(conn, Routes.service_versions_path(conn, :versions, id))
      service = ServiceRepo.get_service!(id)
      all_versions = MetadataRepo.all_versions(service)
      assert length(all_versions) == 2

      last_metadata = List.last(all_versions)
      first_metadata = List.first(all_versions)

      assert json_response(conn, 200) == %{
        "service_id" => service.id,
        "service_name" => service.service_name,
        "versions" => [
          %{
            "version_id" => last_metadata[:version_id],
            "version_number" => last_metadata[:version_number]
          },
          %{
            "version_id" => first_metadata[:version_id],
            "version_number" => first_metadata[:version_number]
          }
        ]
      }
    end
  end

  def fixture(:service) do
    {:ok, service} = ServiceRepo.create_service(@create_attrs)
    service
  end

  defp create_service(_) do
    service = fixture(:service)
    %{service: service}
  end
end
