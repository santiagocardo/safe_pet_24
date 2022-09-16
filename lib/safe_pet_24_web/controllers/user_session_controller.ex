defmodule SafePet24Web.UserSessionController do
  use SafePet24Web, :controller

  alias SafePet24.Accounts
  alias SafePet24.Accounts.User
  alias SafePet24Web.UserAuth

  plug :put_root_layout, "session.html"

  def new(conn, _params) do
    conn
    |> assign(:page_title, "Iniciar Sesión")
    |> render("new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    case Accounts.get_user_by_email_and_password(email, password) do
      %User{confirmed_at: nil} ->
        conn
        |> put_flash(:error, "Debes confirmar tu cuenta para acceder a esta página.")
        |> redirect(to: Routes.user_confirmation_path(conn, :new))

      %User{} = user ->
        UserAuth.log_in_user(conn, user, user_params)

      nil ->
        # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
        render(conn, "new.html", error_message: "Usuario o contraseña inválida")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Sesión terminada exitosamente.")
    |> UserAuth.log_out_user()
  end
end
