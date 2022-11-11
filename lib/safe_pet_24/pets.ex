defmodule SafePet24.Pets do
  @moduledoc """
  The Pets context.
  """

  import Ecto.Query, warn: false

  alias SafePet24.Repo
  alias SafePet24.Pets.Pet
  alias SafePet24.Pets.Disease
  alias SafePet24.Pets.Vaccine
  alias SafePet24.Pets.Medication

  @doc """
  Returns the list of pets by user_id.

  ## Examples

      iex> list_pets(user_id)
      [%Pet{}, ...]

  """
  def list_pets(user_id) do
    from(p in Pet, where: p.user_id == ^user_id and p.is_deleted == false) |> Repo.all()
  end

  @doc """
  Gets a single pet.

  Raises `Ecto.NoResultsError` if the Pet does not exist.

  ## Examples

      iex> get_pet!(123)
      %Pet{}

      iex> get_pet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pet!(id), do: Repo.get!(Pet, id) |> Repo.preload([:diseases, :vaccines, :medications])

  def get_pet_by_serial(serial),
    do:
      Pet
      |> Repo.get_by(serial: serial, is_deleted: false)
      |> Repo.preload([:diseases, :vaccines, :medications])

  @doc """
  Creates a pet.

  ## Examples

      iex> create_pet(%{field: value})
      {:ok, %Pet{}}

      iex> create_pet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pet(attrs \\ %{}) do
    %Pet{}
    |> Pet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pet.

  ## Examples

      iex> update_pet(pet, %{field: new_value})
      {:ok, %Pet{}}

      iex> update_pet(pet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pet(%Pet{} = pet, attrs) do
    pet
    |> Pet.changeset(attrs)
    |> Repo.update()
    |> maybe_delete_old_photo(pet.photo_url)
  end

  defp maybe_delete_old_photo({:ok, pet}, old_photo_url) when is_binary(old_photo_url) do
    unless pet.photo_url == old_photo_url do
      old_photo_url
      |> String.split(SafePet24.GoogleDrive.base_url())
      |> List.last()
      |> SafePet24.GoogleDrive.delete_file()
    end

    {:ok, pet}
  end

  defp maybe_delete_old_photo(update_result, _old_photo_url), do: update_result

  @doc """
  Deletes a pet.

  ## Examples

      iex> delete_pet(pet)
      {:ok, %Pet{}}

      iex> delete_pet(pet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pet(%Pet{} = pet) do
    Repo.delete(pet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pet changes.

  ## Examples

      iex> change_pet(pet)
      %Ecto.Changeset{data: %Pet{}}

  """
  def change_pet(%Pet{} = pet, attrs \\ %{}) do
    Pet.changeset(pet, attrs)
  end

  def total_pets(user_id),
    do:
      from(p in Pet,
        where: p.user_id == ^user_id and p.is_deleted == false,
        select: fragment("count(*)")
      )
      |> Repo.one()

  def get_disease!(id), do: Repo.get!(Disease, id) |> Repo.preload(:pet)

  def create_disease(attrs \\ %{}) do
    %Disease{}
    |> Disease.changeset(attrs)
    |> Repo.insert()
  end

  def delete_disease(%Disease{} = disease) do
    Repo.delete(disease)
  end

  def change_disease(%Disease{} = disease, attrs \\ %{}) do
    Disease.changeset(disease, attrs)
  end

  def get_vaccine!(id), do: Repo.get!(Vaccine, id) |> Repo.preload(:pet)

  def create_vaccine(attrs \\ %{}) do
    %Vaccine{}
    |> Vaccine.changeset(attrs)
    |> Repo.insert()
  end

  def delete_vaccine(%Vaccine{} = vaccine) do
    Repo.delete(vaccine)
  end

  def change_vaccine(%Vaccine{} = vaccine, attrs \\ %{}) do
    Vaccine.changeset(vaccine, attrs)
  end

  def get_medication!(id), do: Repo.get!(Medication, id) |> Repo.preload(:pet)

  def create_medication(attrs \\ %{}) do
    %Medication{}
    |> Medication.changeset(attrs)
    |> Repo.insert()
  end

  def delete_medication(%Medication{} = medication) do
    Repo.delete(medication)
  end

  def change_medication(%Medication{} = medication, attrs \\ %{}) do
    Medication.changeset(medication, attrs)
  end
end
