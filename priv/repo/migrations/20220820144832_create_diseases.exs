defmodule SafePet24.Repo.Migrations.CreateDiseases do
  use Ecto.Migration

  def change do
    create table(:diseases) do
      add :name, :string, null: false
      add :care, :string
      add :pet_id, references(:pets, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:diseases, [:pet_id])
  end
end
