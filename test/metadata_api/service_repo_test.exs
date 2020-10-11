defmodule MetadataApi.ServiceRepoTest do
  use MetadataApi.DataCase

  alias MetadataApi.ServiceRepo

  describe "services" do
    alias MetadataApi.ServiceRepo.Service

    @valid_attrs %{
      "metadata" => %{
        "service_name" => "some name",
        "data" => %{},
        "created_by" => "1",
        "updated_by" => "1"
      }
    }
    @update_attrs %{
      "metadata" => %{
        "service_name" => "some updated name",
        "data" => %{ "title" => "some updated title" },
        "created_by" => "1",
        "updated_by" => "1"
      }
    }
    @invalid_attrs %{service_name: nil}

    def service_fixture(attrs \\ %{}) do
      {:ok, service} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ServiceRepo.create_service()

      service
    end

    @tag :skip
    test "list_services/0 returns all services" do
      service = service_fixture()
      assert ServiceRepo.list_services() == [service]
    end

    @tag :skip
    test "get_service!/1 returns the service with given id" do
      service = service_fixture()
      assert ServiceRepo.get_service!(service.id) == service
    end

    test "create_service/1 with valid data creates a service metadata" do
      assert {:ok, %Service{} = service} = ServiceRepo.create_service(@valid_attrs)
      assert service.service_name == "some name"
      assert List.last(service.metadata).data == %{"created_by" => "1", "data" => %{}, "service_name" => "some name", "updated_by" => "1"}
    end

    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ServiceRepo.create_service(@invalid_attrs)
    end

    @tag :skip
    test "update_service/2 with valid data updates the service" do
      service = service_fixture()
      assert {:ok, %Service{} = service} = ServiceRepo.update_service(service, @update_attrs)
      assert service.service_name == "some updated name"
    end

    @tag :skip
    test "update_service/2 with invalid data returns error changeset" do
      service = service_fixture()
      assert {:error, %Ecto.Changeset{}} = ServiceRepo.update_service(service, @invalid_attrs)
      assert service == ServiceRepo.get_service!(service.id)
    end

    test "delete_service/1 deletes the service" do
      service = service_fixture()
      assert {:ok, %Service{}} = ServiceRepo.delete_service(service)
      assert_raise Ecto.NoResultsError, fn -> ServiceRepo.get_service!(service.id) end
    end

    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = ServiceRepo.change_service(service)
    end
  end
end
