defmodule SafePet24.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> validate_required([:name, :phone, :email, :address, :user_id])
    |> validate_length(:name, min: 4, max: 24)
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, SafePet24.Repo)
    |> unique_constraint(:email)
  end
end
