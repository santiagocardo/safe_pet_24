defmodule SafePet24Web.UserResetPasswordController do
  use SafePet24Web, :controller

  alias SafePet24.Accounts

  plug :put_root_layout, "session.html"
  plug :get_user_by_reset_password_token when action in [:edit, :update]

  def new(conn, _params) do
    conn
    |> assign(:page_title, "Restablecer Contraseña")
    |> render("new.html")
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &Routes.user_reset_password_url(conn, :edit, &1)
      )
    end

    conn
    |> put_flash(
      :info,
      "Si su correo electrónico está en nuestro sistema, recibirá instrucciones para restablecer su contraseña en breve."
    )
    |> redirect(to: Routes.user_session_path(conn, :new))
  end

  def edit(conn, _params) do
    render(conn, "edit.html", changeset: Accounts.change_user_password(conn.assigns.user))
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def update(conn, %{"user" => user_params}) do
    case Accounts.reset_user_password(conn.assigns.user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "La contraseña ha sido restablecida con éxito.")
        |> redirect(to: Routes.user_session_path(conn, :new))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  defp get_user_by_reset_password_token(conn, _opts) do
    %{"token" => token} = conn.params

    if user = Accounts.get_user_by_reset_password_token(token) do
      conn |> assign(:user, user) |> assign(:token, token)
    else
      conn
      |> put_flash(:error, "El enlace para restablecer la contraseña no es válido o ha caducado.")
      |> redirect(to: Routes.user_session_path(conn, :new))
      |> halt()
    end
  end
end
