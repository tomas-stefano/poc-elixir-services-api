defmodule MetadataApi.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :service_name, :string

      timestamps()
    end

    create index(:services, :service_name)
  end
end
