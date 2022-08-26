defmodule SafePet24.ContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SafePet24.Contacts` context.
  """

  @doc """
  Generate a contact.
  """
  def contact_fixture(attrs \\ %{}) do
    {:ok, contact} =
      attrs
      |> Enum.into(%{
        address: "some address",
        email: "some email",
        name: "some name",
        phone: "some phone"
      })
      |> SafePet24.Contacts.create_contact()

    contact
  end
end
