defmodule SafePet24Web.UserConfirmationController do
  use SafePet24Web, :controller

  alias SafePet24.Accounts

  plug :put_root_layout, "session.html"

  def new(conn, _params) do
    conn
    |> assign(:page_title, "Confirmar Usuario")
    |> render("new.html")
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &Routes.user_confirmation_url(conn, :edit, &1)
      )
    end

    conn
    |> put_flash(
      :info,
      "Si su correo electrónico está en nuestro sistema y aún no ha sido confirmado, recibirá un correo electrónico con instrucciones en breve."
    )
    |> redirect(to: "/")
  end

  def edit(conn, %{"token" => token}) do
    render(conn, "edit.html", token: token)
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def update(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Usuario confirmado exitosamente.")
        |> redirect(to: "/")

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: "/")

          %{} ->
            conn
            |> put_flash(:error, "El enlace de confirmación no es válido o ha expirado.")
            |> redirect(to: "/")
        end
    end
  end
end
