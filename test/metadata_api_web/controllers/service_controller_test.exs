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
      _service_name = @create_attrs[:metadata][:service_name]
      _created_by = @create_attrs[:metadata][:created_by]
      _updated_by = @create_attrs[:metadata][:updated_by]

      assert %{
        "metadata" => %{
          "service_id" => id,
          "service_name" => _service_name,
          "created_by" => _created_by,
          "updated_by" => _updated_by,
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

    test "creates more metadata version", %{conn: conn, service: %Service{id: id}} do
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
          "created_by" => ["can't be blank"],
          "updated_by" => ["can't be blank"]
        }
      }
    end
  end

  describe "GET /services/:id/versions" do
    test "returns all metadata versions", %{conn: conn} do
      conn = post(conn, Routes.service_path(conn, :create), @create_attrs)
      id = json_response(conn, 201)["metadata"]["service_id"]

      conn = put(conn, Routes.service_path(conn, :update, id), @update_attrs)
      assert MetadataRepo.count == 2
      versions = MetadataRepo.all

      # order by inserted at desc mean the last updated is the first one
      last_metadata = List.first(versions)
      first_metadata = List.last(versions)
      service = ServiceRepo.get_service!(id)

      conn = get(conn, Routes.service_versions_path(conn, :versions, id))

      assert json_response(conn, 200) == %{
        "service_id" => service.id,
        "service_name" => service.service_name,
        "versions" => [
          %{
            "version_id" => last_metadata.version_id,
            "version_number" => last_metadata.version_number,
            "created_at" => NaiveDateTime.to_iso8601(last_metadata.inserted_at)
          },
          %{
            "version_id" => first_metadata.version_id,
            "version_number" => first_metadata.version_number,
            "created_at" => NaiveDateTime.to_iso8601(first_metadata.inserted_at)
          }
        ]
      }
    end
  end

  describe "GET /services/:id/versions/:version_id" do
    test "returns the metadata version", %{conn: conn} do
      conn = post(conn, Routes.service_path(conn, :create), @create_attrs)
      id = json_response(conn, 201)["metadata"]["service_id"]

      conn = put(conn, Routes.service_path(conn, :update, id), @update_attrs)
      assert MetadataRepo.count == 2
      versions = MetadataRepo.all

      # order by inserted at desc mean the last updated is the first one
      metadata = List.first(versions)
      service = ServiceRepo.get_service!(id)

      conn = get(conn, Routes.service_version_path(conn, :version, id, metadata.version_id))

      assert json_response(conn, 200) == %{
        "service_name" => service.service_name,
        "service_id" => service.id,
        "version_id" => metadata.version_id,
        "version_number" => metadata.version_number,
        "created_at" => NaiveDateTime.to_iso8601(metadata.inserted_at),
        "updated_at" => NaiveDateTime.to_iso8601(metadata.updated_at),
        "created_by" => metadata.created_by,
        "updated_by" => metadata.updated_by,
        "pages" => [%{"url" => "/"}]
      }
    end
  end

  describe "GET /services/user/:user_id" do
    test "returns all services from an user", %{conn: conn} do
      conn = post(
        conn,
        Routes.service_path(conn, :create),
        %{
           "metadata" => %{
             "service_name" => "Formatron",
             "created_by" => "1234",
             "updated_by" => "1234",
             "pages" => [
               %{ url: "/" }
             ]
           }
        }
      )
      first_service = json_response(conn, 201)["metadata"]["service_id"]
      conn = post(
        conn,
        Routes.service_path(conn, :create),
        %{
           "metadata" => %{
             "service_name" => "Metatron",
             "created_by" => "1234",
             "updated_by" => "1234",
             "pages" => [
               %{ url: "/" }
             ]
           }
        }
      )
      second_service = json_response(conn, 201)["metadata"]["service_id"]
      post(
        conn,
        Routes.service_path(conn, :create),
        %{
           "metadata" => %{
             "service_name" => "Greedo",
             "created_by" => "12345",
             "updated_by" => "12345",
             "pages" => [
               %{ url: "/" }
             ]
           }
        }
      )
      conn = get(conn, Routes.services_user_path(conn, :list_services_from_user, "1234"))
      assert %{
        "services" => [
          %{
            "service_id" => first_service,
            "service_name" => "Formatron"
          },
          %{
            "service_id" => second_service,
            "service_name" => "Metatron"
          }
        ]
      } == json_response(conn, 200)
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
