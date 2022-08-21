defmodule SafePet24Web.PetControllerTest do
  use SafePet24Web.ConnCase

  import SafePet24.PetsFixtures

  @create_attrs %{birthdate: ~D[2022-08-05], breed: "some breed", color: "some color", consumption_frequency: "some consumption_frequency", food_brand: "some food_brand", food_type: "some food_type", name: "some name", reproductive_status: "some reproductive_status", reward: "some reward", species: "some species", weight: 42}
  @update_attrs %{birthdate: ~D[2022-08-06], breed: "some updated breed", color: "some updated color", consumption_frequency: "some updated consumption_frequency", food_brand: "some updated food_brand", food_type: "some updated food_type", name: "some updated name", reproductive_status: "some updated reproductive_status", reward: "some updated reward", species: "some updated species", weight: 43}
  @invalid_attrs %{birthdate: nil, breed: nil, color: nil, consumption_frequency: nil, food_brand: nil, food_type: nil, name: nil, reproductive_status: nil, reward: nil, species: nil, weight: nil}

  describe "index" do
    test "lists all pets", %{conn: conn} do
      conn = get(conn, Routes.pet_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Pets"
    end
  end

  describe "new pet" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.pet_path(conn, :new))
      assert html_response(conn, 200) =~ "New Pet"
    end
  end

  describe "create pet" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.pet_path(conn, :create), pet: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.pet_path(conn, :show, id)

      conn = get(conn, Routes.pet_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Pet"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.pet_path(conn, :create), pet: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Pet"
    end
  end

  describe "edit pet" do
    setup [:create_pet]

    test "renders form for editing chosen pet", %{conn: conn, pet: pet} do
      conn = get(conn, Routes.pet_path(conn, :edit, pet))
      assert html_response(conn, 200) =~ "Edit Pet"
    end
  end

  describe "update pet" do
    setup [:create_pet]

    test "redirects when data is valid", %{conn: conn, pet: pet} do
      conn = put(conn, Routes.pet_path(conn, :update, pet), pet: @update_attrs)
      assert redirected_to(conn) == Routes.pet_path(conn, :show, pet)

      conn = get(conn, Routes.pet_path(conn, :show, pet))
      assert html_response(conn, 200) =~ "some updated breed"
    end

    test "renders errors when data is invalid", %{conn: conn, pet: pet} do
      conn = put(conn, Routes.pet_path(conn, :update, pet), pet: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Pet"
    end
  end

  describe "delete pet" do
    setup [:create_pet]

    test "deletes chosen pet", %{conn: conn, pet: pet} do
      conn = delete(conn, Routes.pet_path(conn, :delete, pet))
      assert redirected_to(conn) == Routes.pet_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.pet_path(conn, :show, pet))
      end
    end
  end

  defp create_pet(_) do
    pet = pet_fixture()
    %{pet: pet}
  end
end
