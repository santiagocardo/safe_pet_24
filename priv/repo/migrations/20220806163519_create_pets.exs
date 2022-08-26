defmodule SafePet24.Repo.Migrations.CreatePets do
  use Ecto.Migration

  def change do
    create table(:pets) do
      add :name, :string, null: false
      add :serial, :string, null: false
      add :reward, :string
      add :birthdate, :date, null: false
      add :species, :string, null: false
      add :breed, :string, null: false
      add :color, :string
      add :reproductive_status, :string
      add :weight, :integer
      add :food_type, :string
      add :consumption_frequency, :string
      add :food_brand, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:pets, [:user_id])
    create unique_index(:pets, [:serial])
  end
end
