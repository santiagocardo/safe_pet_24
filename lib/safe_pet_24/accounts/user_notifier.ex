defmodule SafePet24.Accounts.UserNotifier do
  import Swoosh.Email

  alias SafePet24.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"SafePet24", "info@safepet24.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Instrucciones de confirmación de cuenta", """

    ==============================

    Hola #{user.email},

    Puede confirmar su cuenta visitando la siguiente URL:

    #{url}

    Si no has creado una cuenta con nosotros, ignora esto.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Instrucciones para restablecer la contraseña", """

    ==============================

    Hola #{user.email},

    Puede restablecer su contraseña visitando la siguiente URL:

    #{url}

    Si no has solicitado este cambio, por favor ignora esto.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Instrucciones para actualizar el correo electrónico", """

    ==============================

    Hola #{user.email},

    Puede cambiar su correo electrónico visitando la siguiente URL:

    #{url}

    Si no has solicitado este cambio, por favor ignora esto.

    ==============================
    """)
  end

  def deliver_pet_found_notification(user, pet, coords) do
    deliver(user.email, "Tu mascota ha sido encontrada", """

    ==============================

    Hola #{user.name},

    Se ha escaneado el código de #{pet.name}. Por favor conserva la calma, te invitamos a validar que se encuentre bien.

    El código se escaneó en esta ubicación: https://maps.google.com/maps?q=#{coords}

    ==============================
    """)
  end
end
