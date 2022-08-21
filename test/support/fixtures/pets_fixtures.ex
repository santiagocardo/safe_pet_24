defmodule SafePet24.PetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SafePet24.Pets` context.
  """

  @doc """
  Generate a pet.
  """
  def pet_fixture(attrs \\ %{}) do
    {:ok, pet} =
      attrs
      |> Enum.into(%{
        birthdate: ~D[2022-08-05],
        breed: "some breed",
        color: "some color",
        consumption_frequency: "some consumption_frequency",
        food_brand: "some food_brand",
        food_type: "some food_type",
        name: "some name",
        reproductive_status: "some reproductive_status",
        reward: "some reward",
        species: "some species",
        weight: 42
      })
      |> SafePet24.Pets.create_pet()

    pet
  end
end
