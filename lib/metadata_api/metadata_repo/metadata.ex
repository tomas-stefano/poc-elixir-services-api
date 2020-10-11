defmodule MetadataApi.MetadataRepo.Metadata do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "metadata" do
    field :created_by, :string
    field :data, :map
    field :locale, :string
    field :updated_by, :string
    field :version_id, Ecto.UUID, autogenerate: true
    field :version_number, :integer
    belongs_to :service, MetadataApi.ServiceRepo.Service

    timestamps()
  end

  @doc false
  def changeset(metadata, attrs) do
    metadata
    |> cast(attrs, [:data, :locale, :created_by, :updated_by, :version_id, :version_number])
    |> validate_required([:data, :created_by, :updated_by])
  end
end
