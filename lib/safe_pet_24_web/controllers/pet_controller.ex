defmodule SafePet24Web.PetController do
  use SafePet24Web, :controller

  alias SafePet24.Pets
  alias SafePet24.Pets.Pet

  def index(conn, _params) do
    pets = Pets.list_pets()
    render(conn, "index.html", pets: pets)
  end

  def new(conn, _params) do
    changeset = Pets.change_pet(%Pet{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"pet" => pet_params}) do
    pet_params = Map.put(pet_params, "user_id", conn.assigns.current_user.id)

    case Pets.create_pet(pet_params) do
      {:ok, pet} ->
        conn
        |> put_flash(:info, "Mascota registrada exitosamente.")
        |> redirect(to: Routes.pet_path(conn, :show, pet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pet = Pets.get_pet!(id)
    changeset = Pets.change_pet(pet)

    render(conn, "show.html", pet: pet, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    pet = Pets.get_pet!(id)
    changeset = Pets.change_pet(pet)

    render(conn, "edit.html", pet: pet, changeset: changeset)
  end

  def update(conn, %{"id" => id, "pet" => pet_params}) do
    pet = Pets.get_pet!(id)

    case Pets.update_pet(pet, pet_params) do
      {:ok, pet} ->
        conn
        |> put_flash(:info, "Mascota actualizada exitosamente.")
        |> redirect(to: Routes.pet_path(conn, :edit, pet) <> "#content")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", pet: pet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pet = Pets.get_pet!(id)
    {:ok, _pet} = Pets.delete_pet(pet)

    conn
    |> put_flash(:info, "Mascota eliminada exitosamente.")
    |> redirect(to: Routes.pet_path(conn, :index))
  end

  def clinical_profile(conn, %{"id" => id}) do
    pet = Pets.get_pet!(id)
    changeset = Pets.change_pet(pet)
    disease_changeset = Pets.change_disease(%Pets.Disease{})
    vaccine_changeset = Pets.change_vaccine(%Pets.Vaccine{})

    conn
    |> put_session(:current_pet_id, pet.id)
    |> render("clinical_profile.html",
      pet: pet,
      changeset: changeset,
      disease_changeset: disease_changeset,
      vaccine_changeset: vaccine_changeset
    )
  end

  def update_clinical_profile(conn, %{"id" => id, "pet" => pet_params}) do
    pet = Pets.get_pet!(id)

    case Pets.update_pet(pet, pet_params) do
      {:ok, pet} ->
        conn
        |> put_flash(:info, "Mascota actualizada exitosamente.")
        |> redirect(to: Routes.pet_path(conn, :clinical_profile, %{"id" => pet.id}) <> "#content")

      {:error, %Ecto.Changeset{} = changeset} ->
        disease_changeset = Pets.change_disease(%Pets.Disease{})
        vaccine_changeset = Pets.change_vaccine(%Pets.Vaccine{})

        render(conn, "clinical_profile.html",
          pet: pet,
          changeset: changeset,
          disease_changeset: disease_changeset,
          vaccine_changeset: vaccine_changeset
        )
    end
  end

  def create_disease(conn, %{"disease" => disease_params}) do
    pet_id = get_in(conn.private, [:plug_session, "current_pet_id"])
    disease_params = Map.put(disease_params, "pet_id", pet_id)

    case Pets.create_disease(disease_params) do
      {:ok, disease} ->
        conn
        |> put_flash(:info, "Enfermedad registrada exitosamente.")
        |> redirect(
          to: Routes.pet_path(conn, :clinical_profile, %{"id" => disease.pet_id}) <> "#diseases"
        )

      {:error, %Ecto.Changeset{} = disease_changeset} ->
        pet = Pets.get_pet!(pet_id)
        changeset = Pets.change_pet(pet)
        vaccine_changeset = Pets.change_vaccine(%Pets.Vaccine{})

        render(conn, "clinical_profile.html",
          pet: pet,
          changeset: changeset,
          disease_changeset: disease_changeset,
          vaccine_changeset: vaccine_changeset
        )
    end
  end

  def delete_disease(conn, %{"id" => id}) do
    disease = Pets.get_disease!(id)
    {:ok, _pet} = Pets.delete_disease(disease)

    conn
    |> put_flash(:info, "Enfermedad eliminada exitosamente.")
    |> redirect(
      to: Routes.pet_path(conn, :clinical_profile, %{"id" => disease.pet_id}) <> "#diseases"
    )
  end

  def create_vaccine(conn, %{"vaccine" => vaccine_params}) do
    pet_id = get_in(conn.private, [:plug_session, "current_pet_id"])
    vaccine_params = Map.put(vaccine_params, "pet_id", pet_id)

    case Pets.create_vaccine(vaccine_params) do
      {:ok, vaccine} ->
        conn
        |> put_flash(:info, "Vacuna registrada exitosamente.")
        |> redirect(
          to: Routes.pet_path(conn, :clinical_profile, %{"id" => vaccine.pet_id}) <> "#vaccines"
        )

      {:error, %Ecto.Changeset{} = vaccine_changeset} ->
        pet = Pets.get_pet!(pet_id)
        changeset = Pets.change_pet(pet)
        disease_changeset = Pets.change_disease(%Pets.Disease{})

        render(conn, "clinical_profile.html",
          pet: pet,
          changeset: changeset,
          disease_changeset: disease_changeset,
          vaccine_changeset: vaccine_changeset
        )
    end
  end

  def delete_vaccine(conn, %{"id" => id}) do
    vaccine = Pets.get_vaccine!(id)
    {:ok, _pet} = Pets.delete_vaccine(vaccine)

    conn
    |> put_flash(:info, "Vacuna eliminada exitosamente.")
    |> redirect(
      to: Routes.pet_path(conn, :clinical_profile, %{"id" => vaccine.pet_id}) <> "#vaccines"
    )
  end
end
