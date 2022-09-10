defmodule SafePet24.Repo.Migrations.AddEmailUserIdUniqueIndexToContacts do
  use Ecto.Migration

  def change do
    create unique_index(:contacts, [:email, :user_id])
  end
end
