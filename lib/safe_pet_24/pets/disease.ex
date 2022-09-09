defmodule SafePet24.Pets.Disease do
  use Ecto.Schema
  import Ecto.Changeset

  schema "diseases" do
    field :care, :string
    field :name, :string

    belongs_to :pet, SafePet24.Pets.Pet

    timestamps()
  end

  @doc false
  def changeset(diseases, attrs) do
    diseases
    |> cast(attrs, [:name, :care, :pet_id])
    |> validate_required([:name])
    |> validate_length(:name, min: 4, max: 35)
    |> validate_length(:care, min: 4, max: 150)
  end
end
