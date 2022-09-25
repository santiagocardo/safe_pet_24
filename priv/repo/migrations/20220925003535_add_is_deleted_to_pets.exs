defmodule SafePet24.Repo.Migrations.AddIsDeletedToPets do
  use Ecto.Migration

  def change do
    alter table(:pets) do
      add(:is_deleted, :boolean, null: false, default: false)
    end
  end
end
