defmodule SafePet24.Pets.Vaccine do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vaccines" do
    field :date, :date
    field :name, :string

    belongs_to :pet, SafePet24.Pets.Pet

    timestamps()
  end

  @doc false
  def changeset(vaccine, attrs) do
    vaccine
    |> cast(attrs, [:name, :date, :pet_id])
    |> validate_required([:name, :date])
    |> validate_length(:name, min: 4, max: 35)
  end
end
