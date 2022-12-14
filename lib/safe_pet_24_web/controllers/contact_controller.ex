defmodule SafePet24Web.ContactController do
  use SafePet24Web, :controller

  alias SafePet24.Contacts
  alias SafePet24.Contacts.Contact

  def index(conn, _params) do
    contacts = Contacts.list_contacts(conn.assigns.current_user.id)

    conn
    |> assign(:page_title, "Tus Contactos")
    |> render("index.html", contacts: contacts)
  end

  def new(conn, _params) do
    if Contacts.total_contacts(conn.assigns.current_user.id) < 5 do
      changeset = Contacts.change_contact(%Contact{})

      conn
      |> assign(:page_title, "Registrar Contacto")
      |> render("new.html", changeset: changeset)
    else
      conn
      |> put_flash(:warning, "Solo puedes tener 5 contactos como máximo")
      |> redirect(to: Routes.contact_path(conn, :index))
    end
  end

  def create(conn, %{"contact" => contact_params}) do
    contact_params = Map.put(contact_params, "user_id", conn.assigns.current_user.id)

    case Contacts.create_contact(contact_params) do
      {:ok, _contact} ->
        conn
        |> put_flash(:info, "Contacto creado exitosamente.")
        |> redirect(to: Routes.contact_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)

    if contact.user_id == conn.assigns.current_user.id do
      render(conn, "show.html", contact: contact)
    else
      redirect_to_index(conn)
    end
  end

  def edit(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)

    if contact.user_id == conn.assigns.current_user.id do
      changeset = Contacts.change_contact(contact)

      conn
      |> assign(:page_title, "Editar Contacto")
      |> render("edit.html", contact: contact, changeset: changeset)
    else
      redirect_to_index(conn)
    end
  end

  def update(conn, %{"id" => id, "contact" => contact_params}) do
    contact = Contacts.get_contact!(id)

    case Contacts.update_contact(contact, contact_params) do
      {:ok, _contact} ->
        conn
        |> put_flash(:info, "Contacto actualizado exitosamente.")
        |> redirect(to: Routes.contact_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", contact: contact, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    {:ok, _contact} = Contacts.delete_contact(contact)

    conn
    |> put_flash(:info, "Contacto eliminado exitosamente.")
    |> redirect(to: Routes.contact_path(conn, :index))
  end

  defp redirect_to_index(conn) do
    conn
    |> put_flash(:info, "No tienes permisos sobre este contacto.")
    |> redirect(to: Routes.contact_path(conn, :index))
  end
end
