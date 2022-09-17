defmodule SafePet24.Pets.Medication do
  use Ecto.Schema
  import Ecto.Changeset

  schema "medications" do
    field :dosage, :string
    field :frequency, :string
    field :name, :string

    belongs_to :pet, SafePet24.Pets.Pet

    timestamps()
  end

  @doc false
  def changeset(medication, attrs) do
    medication
    |> cast(attrs, [:name, :dosage, :frequency, :pet_id])
    |> validate_required([:name, :dosage, :frequency])
    |> validate_length(:name, min: 4, max: 35)
    |> validate_length(:dosage, min: 1, max: 30)
    |> validate_length(:frequency, min: 1, max: 30)
  end
end
