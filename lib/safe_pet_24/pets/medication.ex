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
    |> cast(attrs, [:name, :dosage, :frequency])
    |> validate_required([:name, :dosage, :frequency])
    |> validate_length(:name, min: 4, max: 24)
  end
end
