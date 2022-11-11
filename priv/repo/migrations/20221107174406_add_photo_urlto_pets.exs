defmodule SafePet24.Repo.Migrations.AddPhotoUrltoPets do
  use Ecto.Migration

  def change do
    alter table(:pets) do
      add(:photo_url, :string)
    end
  end
end
