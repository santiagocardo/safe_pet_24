defmodule SafePet24Web.PageController do
  use SafePet24Web, :controller

  alias SafePet24.Accounts.UserNotifier

  plug :put_root_layout, "pet_info.html"

  def index(conn, %{"serial" => serial} = params) do
    if pet = SafePet24.Pets.get_pet_by_serial(serial) do
      contacts = SafePet24.Contacts.list_contacts(pet.user_id)
      refresh = params["refresh"] || "pending"

      conn
      |> assign(:page_title, "Información de la Mascota")
      |> render("index.html", pet: pet, contacts: contacts, refresh: refresh)
    else
      conn
      |> put_flash(:error, "Mascota no registrada")
      |> redirect(to: Routes.pet_path(conn, :new))
    end
  end

  def send_notification(conn, %{"coords" => coords, "serial" => serial}) do
    pet = SafePet24.Pets.get_pet_by_serial(serial)

    user =
      pet.user_id
      |> SafePet24.Accounts.get_user!()
      |> SafePet24.Repo.preload(:contacts)

    Enum.each(user.contacts, &UserNotifier.deliver_pet_found_notification(&1, pet, coords))

    redirect(conn, to: Routes.page_path(conn, :index, serial) <> "?refresh=done")
  end
end
