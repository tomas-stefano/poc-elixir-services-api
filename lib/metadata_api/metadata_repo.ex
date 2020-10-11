defmodule MetadataApi.MetadataRepo do
  @moduledoc """
  The MetadataRepo context.
  """

  import Ecto.Query, warn: false
  alias MetadataApi.Repo

  alias MetadataApi.MetadataRepo.Metadata

  def all do
    Repo.all(Metadata)
    |> Repo.preload([:service])
  end

  def count do
    Repo.aggregate(Metadata, :count, :id)
  end

  def all_versions(service) do
    Repo.all(
      from metadata in Metadata,
      select: %{version_id: metadata.version_id, version_number: metadata.version_number},
      where: metadata.service_id == ^service.id,
      order_by: [desc: metadata.inserted_at]
    )
  end
end
