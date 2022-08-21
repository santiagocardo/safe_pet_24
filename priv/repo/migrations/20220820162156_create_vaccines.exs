defmodule SafePet24.Repo.Migrations.CreateVaccines do
  use Ecto.Migration

  def change do
    create table(:vaccines) do
      add :name, :string, null: false
      add :date, :date, null: false
      add :pet_id, references(:pets, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:vaccines, [:pet_id])
  end
end
