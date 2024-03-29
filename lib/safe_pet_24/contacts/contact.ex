defmodule SafePet24.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  @phone_length_message "%{count} números incluyendo el indicativo de tu país"

  schema "contacts" do
    field :address, :string
    field :email, :string
    field :name, :string
    field :phone, :string

    belongs_to :user, SafePet24.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :phone, :email, :address, :user_id])
    |> validate_required([:name, :phone, :email, :user_id])
    |> validate_length(:name, min: 4, max: 40)
    |> validate_length(:address, min: 4, max: 80)
    |> validate_length(:phone, min: 6, message: "debe tener al menos #{@phone_length_message}")
    |> validate_length(:phone, max: 18, message: "debe tener máximo #{@phone_length_message}")
    |> validate_format(:phone, ~r/^[\+]?[0-9]*$/, message: "solo debe contener números")
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/,
      message: "debe tener el signo @ y sin espacios"
    )
    |> validate_length(:email, max: 80)
    |> unsafe_validate_unique([:email, :user_id], SafePet24.Repo)
    |> unique_constraint([:email, :user_id])
  end
end
