defmodule SafePet24.Repo.Migrations.AddSerialToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:serial, :string, null: false)
    end

    create unique_index(:users, [:serial])
  end
end
