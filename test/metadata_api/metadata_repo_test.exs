defmodule MetadataApi.MetadataRepoTest do
  use MetadataApi.DataCase

  alias MetadataApi.MetadataRepo

  describe "metadata" do
    alias MetadataApi.MetadataRepo.Metadata

    @valid_attrs %{created_by: "some created_by", data: %{}, locale: "some locale", updated_by: "some updated_by" }
    @update_attrs %{created_by: "some updated created_by", data: %{}, locale: "some updated locale", updated_by: "some updated updated_by"}
    @invalid_attrs %{created_by: nil, data: nil, locale: nil, updated_by: nil, version_id: nil, version_number: nil}

    def metadata_fixture(attrs \\ %{}) do
      {:ok, metadata} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MetadataRepo.create_metadata()

      metadata
    end

    test "list_metadata/0 returns all metadata" do
      metadata = metadata_fixture()
      assert MetadataRepo.list_metadata() == [metadata]
    end

    test "get_metadata!/1 returns the metadata with given id" do
      metadata = metadata_fixture()
      assert MetadataRepo.get_metadata!(metadata.id) == metadata
    end

    test "create_metadata/1 with valid data creates a metadata" do
      assert {:ok, %Metadata{} = metadata} = MetadataRepo.create_metadata(@valid_attrs)
      assert metadata.created_by == "some created_by"
      assert metadata.data == %{}
      assert metadata.locale == "some locale"
      assert metadata.updated_by == "some updated_by"
    end

    test "create_metadata/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MetadataRepo.create_metadata(@invalid_attrs)
    end

    test "update_metadata/2 with valid data updates the metadata" do
      metadata = metadata_fixture()
      assert {:ok, %Metadata{} = metadata} = MetadataRepo.update_metadata(metadata, @update_attrs)
      assert metadata.created_by == "some updated created_by"
      assert metadata.data == %{}
      assert metadata.locale == "some updated locale"
      assert metadata.updated_by == "some updated updated_by"
    end

    test "update_metadata/2 with invalid data returns error changeset" do
      metadata = metadata_fixture()
      assert {:error, %Ecto.Changeset{}} = MetadataRepo.update_metadata(metadata, @invalid_attrs)
      assert metadata == MetadataRepo.get_metadata!(metadata.id)
    end

    test "delete_metadata/1 deletes the metadata" do
      metadata = metadata_fixture()
      assert {:ok, %Metadata{}} = MetadataRepo.delete_metadata(metadata)
      assert_raise Ecto.NoResultsError, fn -> MetadataRepo.get_metadata!(metadata.id) end
    end

    test "change_metadata/1 returns a metadata changeset" do
      metadata = metadata_fixture()
      assert %Ecto.Changeset{} = MetadataRepo.change_metadata(metadata)
    end
  end
end
