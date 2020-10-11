defmodule MetadataApi.Repo.Migrations.CreateMetadata do
  use Ecto.Migration

  def change do
    create table(:metadata, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :data, :jsonb, null: false
      add :locale, :string, default: "en"
      add :created_by, :string, null: false
      add :updated_by, :string, null: false
      add :version_id, :uuid, null: false
      add :version_number, :integer
      add :service_id, references(:services, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:metadata, [:service_id])
    create index(:metadata, [:version_id, :service_id])
    create index(:metadata, [:locale, :service_id])
  end
end
