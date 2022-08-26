defmodule SafePet24Web.UserSessionController do
  use SafePet24Web, :controller

  alias SafePet24.Accounts
  alias SafePet24Web.UserAuth

  plug :put_root_layout, "session.html"

  def new(conn, _params) do
    conn
    |> assign(:page_title, "Iniciar Sesión")
    |> render("new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
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
