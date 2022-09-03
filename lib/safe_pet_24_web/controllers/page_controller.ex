defmodule SafePet24Web.PageController do
  use SafePet24Web, :controller

  plug :put_root_layout, "pet_info.html"

  def index(conn, %{"serial" => serial}) do
    if pet = SafePet24.Pets.get_pet_by_serial(serial) do
      contacts = SafePet24.Contacts.list_contacts(pet.user_id)

      render(conn, "index.html", pet: pet, contacts: contacts)
    else
      conn
      |> put_flash(:error, "Mascota no registrada")
      |> redirect(to: Routes.pet_path(conn, :new))
    end
  end
end
