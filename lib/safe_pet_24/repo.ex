defmodule SafePet24.Repo do
  use Ecto.Repo,
    otp_app: :safe_pet_24,
    adapter: Ecto.Adapters.Postgres
end
