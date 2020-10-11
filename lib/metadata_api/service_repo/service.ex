defmodule MetadataApi.ServiceRepo.Service do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "services" do
    field :service_name, :string

    has_many :metadata, MetadataApi.MetadataRepo.Metadata, on_delete: :delete_all

    timestamps()
  end


  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:service_name])
    |> cast_assoc(:metadata, required: true)
    |> validate_required([:service_name])
  end
end
