defmodule SafePet24.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :name, :string, null: false
      add :phone, :string, null: false
      add :email, :string
      add :address, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:contacts, [:user_id])
  end
end
