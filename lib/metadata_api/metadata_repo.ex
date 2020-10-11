defmodule MetadataApi.MetadataRepo do
  @moduledoc """
  The MetadataRepo context.
  """

  import Ecto.Query, warn: false
  alias MetadataApi.Repo

  alias MetadataApi.MetadataRepo.Metadata

  def count do
    Repo.aggregate(Metadata, :count, :id)
  end
end
