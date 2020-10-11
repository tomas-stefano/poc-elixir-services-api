defmodule MetadataApi.MetadataRepo do
  @moduledoc """
  The MetadataRepo context.
  """

  import Ecto.Query, warn: false
  alias MetadataApi.Repo

  alias MetadataApi.MetadataRepo.Metadata

  @doc """
  Returns the list of metadata.

  ## Examples

      iex> list_metadata()
      [%Metadata{}, ...]

  """
  def list_metadata do
    Repo.all(Metadata)
  end

  @doc """
  Gets a single metadata.

  Raises `Ecto.NoResultsError` if the Metadata does not exist.

  ## Examples

      iex> get_metadata!(123)
      %Metadata{}

      iex> get_metadata!(456)
      ** (Ecto.NoResultsError)

  """
  def get_metadata!(id), do: Repo.get!(Metadata, id)

  @doc """
  Creates a metadata.

  ## Examples

      iex> create_metadata(%{field: value})
      {:ok, %Metadata{}}

      iex> create_metadata(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_metadata(attrs \\ %{}) do
    %Metadata{}
    |> Metadata.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a metadata.

  ## Examples

      iex> update_metadata(metadata, %{field: new_value})
      {:ok, %Metadata{}}

      iex> update_metadata(metadata, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_metadata(%Metadata{} = metadata, attrs) do
    metadata
    |> Metadata.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a metadata.

  ## Examples

      iex> delete_metadata(metadata)
      {:ok, %Metadata{}}

      iex> delete_metadata(metadata)
      {:error, %Ecto.Changeset{}}

  """
  def delete_metadata(%Metadata{} = metadata) do
    Repo.delete(metadata)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking metadata changes.

  ## Examples

      iex> change_metadata(metadata)
      %Ecto.Changeset{data: %Metadata{}}

  """
  def change_metadata(%Metadata{} = metadata, attrs \\ %{}) do
    Metadata.changeset(metadata, attrs)
  end
end
