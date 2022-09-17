defmodule SafePet24Web.PetController do
  use SafePet24Web, :controller

  alias SafePet24.Pets
  alias SafePet24.Pets.Pet

  plug :assign_clinical_profile_changesets
       when action in [
              :clinical_profile,
              :update_clinical_profile,
              :create_disease,
              :create_vaccine,
              :create_medication
            ]

  def index(conn, _params) do
    pets = Pets.list_pets(conn.assigns.current_user.id)

    conn
    |> assign(:page_title, "Tus Mascotas")
    |> render("index.html", pets: pets)
  end

  def new(conn, _params) do
    changeset = Pets.change_pet(%Pet{})

    conn
    |> assign(:page_title, "Registrar Mascota")
    |> render("new.html", changeset: changeset)
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

    if pet.user_id == conn.assigns.current_user.id do
      conn
      |> assign(:page_title, "Ver Mascota")
      |> render("show.html", pet: pet)
    else
      redirect_to_index(conn)
    end
  end

  def edit(conn, %{"id" => id}) do
    pet = Pets.get_pet!(id)

    if pet.user_id == conn.assigns.current_user.id do
      changeset = Pets.change_pet(pet)

      conn
      |> assign(:page_title, "Editar Mascota")
      |> render("edit.html", pet: pet, changeset: changeset)
    else
      redirect_to_index(conn)
    end
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

    if pet.user_id == conn.assigns.current_user.id do
      changeset = Pets.change_pet(pet)

      conn
      |> put_session(:current_pet_id, pet.id)
      |> assign(:page_title, "Perfil Clínico de tu Mascota")
      |> render("clinical_profile.html", pet: pet, changeset: changeset)
    else
      redirect_to_index(conn)
    end
  end

  def update_clinical_profile(conn, %{"id" => id, "kind" => kind, "pet" => pet_params}) do
    pet = Pets.get_pet!(id)

    case Pets.update_pet(pet, pet_params) do
      {:ok, pet} ->
        conn
        |> put_flash(:info, "Mascota actualizada exitosamente.")
        |> redirect(to: Routes.pet_path(conn, :clinical_profile, pet) <> "##{kind}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "clinical_profile.html", pet: pet, changeset: changeset)
    end
  end

  def create_disease(conn, %{"disease" => disease_params}) do
    pet_id = get_in(conn.private, [:plug_session, "current_pet_id"])
    disease_params = Map.put(disease_params, "pet_id", pet_id)

    case Pets.create_disease(disease_params) do
      {:ok, _disease} ->
        conn
        |> put_flash(:info, "Enfermedad registrada exitosamente.")
        |> redirect(to: Routes.pet_path(conn, :clinical_profile, pet_id) <> "#diseases")

      {:error, %Ecto.Changeset{} = disease_changeset} ->
        pet = Pets.get_pet!(pet_id)
        changeset = Pets.change_pet(pet)

        render(conn, "clinical_profile.html",
          pet: pet,
          changeset: changeset,
          disease_changeset: disease_changeset
        )
    end
  end

  def delete_disease(conn, %{"id" => id}) do
    disease = Pets.get_disease!(id)
    {:ok, _pet} = Pets.delete_disease(disease)

    conn
    |> put_flash(:info, "Enfermedad eliminada exitosamente.")
    |> redirect(to: Routes.pet_path(conn, :clinical_profile, disease.pet_id) <> "#diseases")
  end

  def create_vaccine(conn, %{"vaccine" => vaccine_params}) do
    pet_id = get_in(conn.private, [:plug_session, "current_pet_id"])
    vaccine_params = Map.put(vaccine_params, "pet_id", pet_id)

    case Pets.create_vaccine(vaccine_params) do
      {:ok, _vaccine} ->
        conn
        |> put_flash(:info, "Vacuna registrada exitosamente.")
        |> redirect(to: Routes.pet_path(conn, :clinical_profile, pet_id) <> "#vaccines")

      {:error, %Ecto.Changeset{} = vaccine_changeset} ->
        pet = Pets.get_pet!(pet_id)
        changeset = Pets.change_pet(pet)

        render(conn, "clinical_profile.html",
          pet: pet,
          changeset: changeset,
          vaccine_changeset: vaccine_changeset
        )
    end
  end

  def delete_vaccine(conn, %{"id" => id}) do
    vaccine = Pets.get_vaccine!(id)
    {:ok, _pet} = Pets.delete_vaccine(vaccine)

    conn
    |> put_flash(:info, "Vacuna eliminada exitosamente.")
    |> redirect(to: Routes.pet_path(conn, :clinical_profile, vaccine.pet_id) <> "#vaccines")
  end

  def create_medication(conn, %{"medication" => medication_params}) do
    pet_id = get_in(conn.private, [:plug_session, "current_pet_id"])
    medication_params = Map.put(medication_params, "pet_id", pet_id)

    case Pets.create_medication(medication_params) do
      {:ok, _medication} ->
        conn
        |> put_flash(:info, "Medicamento registrado exitosamente.")
        |> redirect(to: Routes.pet_path(conn, :clinical_profile, pet_id) <> "#medications")

      {:error, %Ecto.Changeset{} = medication_changeset} ->
        pet = Pets.get_pet!(pet_id)
        changeset = Pets.change_pet(pet)

        render(conn, "clinical_profile.html",
          pet: pet,
          changeset: changeset,
          medication_changeset: medication_changeset
        )
    end
  end

  def delete_medication(conn, %{"id" => id}) do
    medication = Pets.get_medication!(id)
    {:ok, _pet} = Pets.delete_medication(medication)

    conn
    |> put_flash(:info, "Medicamento eliminado exitosamente.")
    |> redirect(to: Routes.pet_path(conn, :clinical_profile, medication.pet_id) <> "#medications")
  end

  defp assign_clinical_profile_changesets(conn, _opts) do
    conn
    |> assign(:disease_changeset, Pets.change_disease(%Pets.Disease{}))
    |> assign(:vaccine_changeset, Pets.change_vaccine(%Pets.Vaccine{}))
    |> assign(:medication_changeset, Pets.change_medication(%Pets.Medication{}))
  end

  defp redirect_to_index(conn) do
    conn
    |> put_flash(:info, "No tienes permisos sobre esta mascota.")
    |> redirect(to: Routes.pet_path(conn, :index))
  end
end
