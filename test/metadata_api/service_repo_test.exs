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
    @invalid_attrs %{service_name: nil}

    def service_fixture(attrs \\ %{}) do
      {:ok, service} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ServiceRepo.create_service()

      service
    end

    test "create_service/1 with valid data creates a service metadata" do
      assert {:ok, %Service{} = service} = ServiceRepo.create_service(@valid_attrs)
      assert service.service_name == "some name"
      assert List.last(service.metadata).data == %{"created_by" => "1", "data" => %{}, "service_name" => "some name", "updated_by" => "1"}
    end

    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ServiceRepo.create_service(@invalid_attrs)
    end

    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = ServiceRepo.change_service(service)
    end
  end
end
