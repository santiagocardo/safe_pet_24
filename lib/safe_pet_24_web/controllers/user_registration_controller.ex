defmodule SafePet24Web.UserRegistrationController do
  use SafePet24Web, :controller

  alias SafePet24.Accounts
  alias SafePet24.Accounts.User
  alias SafePet24.Contacts
  alias SafePet24Web.UserAuth

  plug :put_root_layout, "session.html"

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})

    conn
    |> assign(:page_title, "Registro")
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        contact_params = Map.put(user_params, "user_id", user.id)

        {:ok, _} = Contacts.create_contact(contact_params)

        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "Usuario creado exitosamente.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
