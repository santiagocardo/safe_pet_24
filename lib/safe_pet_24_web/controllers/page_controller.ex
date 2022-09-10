defmodule SafePet24Web.PageController do
  use SafePet24Web, :controller

  alias SafePet24.Accounts.UserNotifier

  plug :put_root_layout, "pet_info.html"

  def index(conn, %{"serial" => serial} = params) do
    if pet = SafePet24.Pets.get_pet_by_serial(serial) do
      contacts = SafePet24.Contacts.list_contacts(pet.user_id)
      email_status = params["email_status"] || "pending"

      conn
      |> assign(:page_title, "Información de la Mascota")
      |> render("index.html", pet: pet, contacts: contacts, email_status: email_status)
    else
      conn
      |> put_flash(:error, "Mascota no registrada")
      |> redirect(to: Routes.pet_path(conn, :new))
    end
  end

  def create(conn, %{"coords" => coords, "serial" => serial}) do
    pet = SafePet24.Pets.get_pet_by_serial(serial)

    UserNotifier.deliver_pet_found_notification(conn.assigns.current_user, pet, coords)

    conn
    |> put_flash(:info, "Correo al propietario ha sido enviado.")
    |> redirect(to: Routes.page_path(conn, :index, serial) <> "?email_status=sent")
  end
end
