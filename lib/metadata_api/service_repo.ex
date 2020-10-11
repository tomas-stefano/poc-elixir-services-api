defmodule MetadataApi.ServiceRepo do
  @moduledoc """
  The ServiceRepo context.
  """

  import Ecto.Query, warn: false
  alias MetadataApi.Repo

  alias MetadataApi.ServiceRepo.Service
  alias MetadataApi.MetadataRepo.Metadata

  def all do
    Repo.all(Service)
    |> Repo.preload(:metadata)
  end

  def count do
    Repo.aggregate(Service, :count, :id)
  end

  @doc """
  Returns the list of services.

  ## Examples

      iex> list_services()
      [%Service{}, ...]

  """
  def list_services do
    Repo.all(Service)
  end

  def list_services_from_user(user_id) do
    metadata = Metadata
    Repo.all(
      from services in Service,
      join: m in ^metadata,
      on: [service_id: services.id, created_by: ^user_id]
    )
  end

  @doc """
  Gets a single service.

  Raises `Ecto.NoResultsError` if the Service does not exist.

  ## Examples

      iex> get_service!(123)
      %Service{}

      iex> get_service!(456)
      ** (Ecto.NoResultsError)

  """
  def get_service!(id), do: Repo.get!(Service, id)

  def last_metadata!(id) do
    Repo.one(
      from metadata in Metadata,
      where: metadata.service_id == ^id,
      order_by: [desc: metadata.inserted_at], limit: 1
    )
  end

  @doc """
  Creates a service.

  ## Examples

      iex> create_service(%{field: value})
      {:ok, %Service{}}

      iex> create_service(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_service(attrs \\ %{}) do
    %Service{}
    |> Service.changeset(prepare_attributes(attrs))
    |> Repo.insert()
  end

  @doc """
  Deletes a service.

  ## Examples

      iex> delete_service(service)
      {:ok, %Service{}}

      iex> delete_service(service)
      {:error, %Ecto.Changeset{}}

  """
  def delete_service(%Service{} = service) do
    Repo.delete(service)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking service changes.

  ## Examples

      iex> change_service(service)
      %Ecto.Changeset{data: %Service{}}

  """
  def change_service(%Service{} = service, attrs \\ %{}) do
    Service.changeset(service, attrs)
  end

  defp prepare_attributes(attrs) do
    metadata = attrs["metadata"]

    if metadata do
    %{
      service_name: metadata["service_name"],
      metadata: [%{
        data: metadata,
        created_by: metadata["created_by"],
        updated_by: metadata["updated_by"]
      }]
    }
    else
      %{}
    end
  end
end
