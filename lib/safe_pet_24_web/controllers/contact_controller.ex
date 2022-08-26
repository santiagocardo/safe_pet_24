defmodule SafePet24Web.ContactController do
  use SafePet24Web, :controller

  alias SafePet24.Contacts
  alias SafePet24.Contacts.Contact

  def index(conn, _params) do
    contacts = Contacts.list_contacts()

    conn
    |> assign(:page_title, "Tus Contactos")
    |> render("index.html", contacts: contacts)
  end

  def new(conn, _params) do
    changeset = Contacts.change_contact(%Contact{})

    conn
    |> assign(:page_title, "Registrar Contacto")
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"contact" => contact_params}) do
    contact_params = Map.put(contact_params, "user_id", conn.assigns.current_user.id)

    case Contacts.create_contact(contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contacto creado existosamente.")
        |> redirect(to: Routes.contact_path(conn, :show, contact))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    render(conn, "show.html", contact: contact)
  end

  def edit(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    changeset = Contacts.change_contact(contact)

    conn
    |> assign(:page_title, "Editar Contacto")
    |> render("edit.html", contact: contact, changeset: changeset)
  end

  def update(conn, %{"id" => id, "contact" => contact_params}) do
    contact = Contacts.get_contact!(id)

    case Contacts.update_contact(contact, contact_params) do
      {:ok, _contact} ->
        conn
        |> put_flash(:info, "Contacto actualizado existosamente.")
        |> redirect(to: Routes.contact_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", contact: contact, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    {:ok, _contact} = Contacts.delete_contact(contact)

    conn
    |> put_flash(:info, "Contacto eliminado existosamente.")
    |> redirect(to: Routes.contact_path(conn, :index))
  end
end
