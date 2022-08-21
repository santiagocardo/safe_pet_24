defmodule SafePet24.Repo.Migrations.CreateMedications do
  use Ecto.Migration

  def change do
    create table(:medications) do
      add :name, :string, null: false
      add :dosage, :string, null: false
      add :frequency, :string, null: false
      add :pet_id, references(:pets, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:medications, [:pet_id])
  end
end
