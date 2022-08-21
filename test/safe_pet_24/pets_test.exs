defmodule SafePet24.PetsTest do
  use SafePet24.DataCase

  alias SafePet24.Pets

  describe "pets" do
    alias SafePet24.Pets.Pet

    import SafePet24.PetsFixtures

    @invalid_attrs %{birthdate: nil, breed: nil, color: nil, consumption_frequency: nil, food_brand: nil, food_type: nil, name: nil, reproductive_status: nil, reward: nil, species: nil, weight: nil}

    test "list_pets/0 returns all pets" do
      pet = pet_fixture()
      assert Pets.list_pets() == [pet]
    end

    test "get_pet!/1 returns the pet with given id" do
      pet = pet_fixture()
      assert Pets.get_pet!(pet.id) == pet
    end

    test "create_pet/1 with valid data creates a pet" do
      valid_attrs = %{birthdate: ~D[2022-08-05], breed: "some breed", color: "some color", consumption_frequency: "some consumption_frequency", food_brand: "some food_brand", food_type: "some food_type", name: "some name", reproductive_status: "some reproductive_status", reward: "some reward", species: "some species", weight: 42}

      assert {:ok, %Pet{} = pet} = Pets.create_pet(valid_attrs)
      assert pet.birthdate == ~D[2022-08-05]
      assert pet.breed == "some breed"
      assert pet.color == "some color"
      assert pet.consumption_frequency == "some consumption_frequency"
      assert pet.food_brand == "some food_brand"
      assert pet.food_type == "some food_type"
      assert pet.name == "some name"
      assert pet.reproductive_status == "some reproductive_status"
      assert pet.reward == "some reward"
      assert pet.species == "some species"
      assert pet.weight == 42
    end

    test "create_pet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pets.create_pet(@invalid_attrs)
    end

    test "update_pet/2 with valid data updates the pet" do
      pet = pet_fixture()
      update_attrs = %{birthdate: ~D[2022-08-06], breed: "some updated breed", color: "some updated color", consumption_frequency: "some updated consumption_frequency", food_brand: "some updated food_brand", food_type: "some updated food_type", name: "some updated name", reproductive_status: "some updated reproductive_status", reward: "some updated reward", species: "some updated species", weight: 43}

      assert {:ok, %Pet{} = pet} = Pets.update_pet(pet, update_attrs)
      assert pet.birthdate == ~D[2022-08-06]
      assert pet.breed == "some updated breed"
      assert pet.color == "some updated color"
      assert pet.consumption_frequency == "some updated consumption_frequency"
      assert pet.food_brand == "some updated food_brand"
      assert pet.food_type == "some updated food_type"
      assert pet.name == "some updated name"
      assert pet.reproductive_status == "some updated reproductive_status"
      assert pet.reward == "some updated reward"
      assert pet.species == "some updated species"
      assert pet.weight == 43
    end

    test "update_pet/2 with invalid data returns error changeset" do
      pet = pet_fixture()
      assert {:error, %Ecto.Changeset{}} = Pets.update_pet(pet, @invalid_attrs)
      assert pet == Pets.get_pet!(pet.id)
    end

    test "delete_pet/1 deletes the pet" do
      pet = pet_fixture()
      assert {:ok, %Pet{}} = Pets.delete_pet(pet)
      assert_raise Ecto.NoResultsError, fn -> Pets.get_pet!(pet.id) end
    end

    test "change_pet/1 returns a pet changeset" do
      pet = pet_fixture()
      assert %Ecto.Changeset{} = Pets.change_pet(pet)
    end
  end
end
