defmodule SafePet24.Pets.Pet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pets" do
    field :birthdate, :date
    field :breed, :string
    field :color, :string
    field :consumption_frequency, :string
    field :food_brand, :string
    field :food_type, :string
    field :name, :string
    field :reproductive_status, :string
    field :reward, :string
    field :serial, :string
    field :species, :string
    field :weight, :integer

    belongs_to :user, SafePet24.Accounts.User
    has_many :diseases, SafePet24.Pets.Disease, on_replace: :delete
    has_many :vaccines, SafePet24.Pets.Vaccine, on_replace: :delete
    has_many :medications, SafePet24.Pets.Medication, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [
      :name,
      :reward,
      :birthdate,
      :species,
      :breed,
      :color,
      :reproductive_status,
      :weight,
      :food_type,
      :consumption_frequency,
      :food_brand,
      :serial,
      :user_id
    ])
    |> cast_assoc(:diseases)
    |> cast_assoc(:vaccines)
    |> cast_assoc(:medications)
    |> validate_required([:name, :birthdate, :species, :breed, :serial, :user_id])
    |> validate_length(:serial, min: 6, max: 24)
    |> unsafe_validate_unique(:serial, SafePet24.Repo)
    |> unique_constraint(:serial)
    |> validate_change(:serial, fn :serial, serial ->
      serials = SafePet24.SerialsCache.get()

      if serial in serials, do: [], else: [serial: "serial no válido"]
    end)
  end
end
