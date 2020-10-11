defmodule MetadataApi.MetadataRepo do
  @moduledoc """
  The MetadataRepo context.
  """

  import Ecto.Query, warn: false
  alias MetadataApi.Repo

  alias MetadataApi.MetadataRepo.Metadata

  def all do
    Repo.all(from metadata in Metadata, order_by: [desc: metadata.inserted_at])
    |> Repo.preload([:service])
  end

  def count do
    Repo.aggregate(Metadata, :count, :id)
  end

  def all_versions(service) do
    Repo.all(
      from metadata in Metadata,
      select: %{
        inserted_at: metadata.inserted_at,
        version_id: metadata.version_id,
        version_number: metadata.version_number
      },
      where: metadata.service_id == ^service.id,
      order_by: [desc: metadata.inserted_at]
    )
  end

  def get_version(service_id: service_id, version_id: version_id) do
    Repo.one(
      from metadata in Metadata,
      where: metadata.service_id == ^service_id and metadata.version_id == ^version_id
    )
    |> Repo.preload(:service)
  end

  def create(service, attrs \\ %{}) do
    attributes = prepare_attributes(Map.merge(attrs, %{"service_id" => service.id}))

    %Metadata{}
    |> Metadata.changeset(attributes)
    |> Repo.insert()
  end

  defp prepare_attributes(attrs) do
    metadata = attrs["metadata"]

    if metadata do
      %{
        data: metadata,
        created_by: metadata["created_by"],
        updated_by: metadata["updated_by"],
        service_id: attrs["service_id"]
      }
    else
      %{}
    end
  end
end
