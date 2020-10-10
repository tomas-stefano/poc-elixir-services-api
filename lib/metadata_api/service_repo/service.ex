defmodule MetadataApi.ServiceRepo.Service do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "services" do
    field :service_name, :string

    timestamps()
  end


  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:service_name])
    |> validate_required([:service_name])
  end
end
