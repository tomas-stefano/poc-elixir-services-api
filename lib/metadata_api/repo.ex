defmodule MetadataApi.Repo do
  use Ecto.Repo,
    otp_app: :metadata_api,
    adapter: Ecto.Adapters.Postgres
end
