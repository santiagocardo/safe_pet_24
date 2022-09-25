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
    field :is_deleted, :boolean, default: false

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
      :user_id,
      :is_deleted
    ])
    |> cast_assoc(:diseases)
    |> cast_assoc(:vaccines)
    |> cast_assoc(:medications)
    |> validate_required([:name, :birthdate, :species, :breed, :serial, :reward, :user_id])
    |> validate_length(:name, min: 2, max: 50)
    |> validate_length(:serial, min: 6, max: 24)
    |> validate_length(:breed, min: 2, max: 30)
    |> validate_length(:color, min: 2, max: 30)
    |> validate_number(:weight, greater_than: 1, less_than_or_equal_to: 99)
    |> validate_length(:food_type, min: 2, max: 40)
    |> validate_length(:consumption_frequency, min: 2, max: 30)
    |> validate_length(:food_brand, min: 2, max: 40)
    |> validate_length(:reward, min: 1, max: 9_999_999_999)
    |> unsafe_validate_unique(:serial, SafePet24.Repo, message: "ya está en uso")
    |> unique_constraint(:serial, message: "ya está en uso")
    |> validate_change(:serial, fn :serial, serial ->
      serials = SafePet24.SerialsCache.get()

      if serial in serials, do: [], else: [serial: "serial no válido"]
    end)
  end
end
