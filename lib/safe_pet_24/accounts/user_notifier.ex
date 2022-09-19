defmodule SafePet24.Accounts.UserNotifier do
  import Swoosh.Email

  alias SafePet24.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, text_body, html_body) do
    email =
      new()
      |> to(recipient)
      |> from({"SafePet24", "info@safepet24.com"})
      |> subject(subject)
      |> text_body(text_header() <> text_body <> text_footer())
      |> html_body(html_header() <> html_body <> html_footer())

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    text_body = """
    Hola #{user.name},

    Puede confirmar su cuenta visitando la siguiente URL:

    #{url}

    Si no has creado una cuenta con nosotros, ignora esto.
    """

    html_body = """
    <p>Hola #{user.name},</p>
    <p>Puede confirmar su cuenta visitando la siguiente URL:</p>
    <p>#{url}</p>
    <p>Si no has solicitado este cambio, por favor ignora esto.</p>
    """

    deliver(user.email, "Instrucciones de confirmación de cuenta", text_body, html_body)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    text_body = """
    Hola #{user.name},

    Puede restablecer su contraseña visitando la siguiente URL:

    #{url}

    Si no has solicitado este cambio, por favor ignora esto.
    """

    html_body = """
    <p>Hola #{user.name},</p>
    <p>Puede restablecer su contraseña visitando la siguiente URL:</p>
    <p>#{url}</p>
    <p>Si no has solicitado este cambio, por favor ignora esto.</p>
    """

    deliver(user.email, "Instrucciones para restablecer la contraseña", text_body, html_body)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    text_body = """
    Hola #{user.name},

    Puede cambiar su correo electrónico visitando la siguiente URL:

    #{url}

    Si no has solicitado este cambio, por favor ignora esto.
    """

    html_body = """
    <p>Hola #{user.name},</p>
    <p>Puede cambiar su correo electrónico visitando la siguiente URL:</p>
    <p>#{url}</p>
    <p>Si no has solicitado este cambio, por favor ignora esto.</p>
    """

    deliver(
      user.email,
      "Instrucciones para actualizar el correo electrónico",
      text_body,
      html_body
    )
  end

  def deliver_pet_found_notification(user, pet, coords) do
    text_body = """
    Hola #{user.name},

    Se ha escaneado el código de #{pet.name}. Por favor conserva la calma, te invitamos a validar que se encuentre bien.

    El código se ha escanedo en esta ubicación: https://maps.google.com/maps?q=#{coords}
    """

    html_body = """
    <p>Hola #{user.name},</p>
    <p>Se ha escaneado el código de #{pet.name}. Por favor conserva la calma, te invitamos a validar que se encuentre bien.</p>
    <p>El código se ha escanedo en esta ubicación: https://maps.google.com/maps?q=#{coords}</p>
    """

    deliver(user.email, "Tu mascota ha sido encontrada", text_body, html_body)
  end

  defp text_header do
    """

    ==============================

    """
  end

  defp text_footer do
    """

    ==============================

    https://www.facebook.com/SafePet24
    https://www.instagram.com/safepet24
    """
  end

  defp html_header do
    """
    <img src="https://safepet24.com/wp-content/uploads/2022/07/Logo1.png" alt="logo" style="max-width: 250px" />
    """
  end

  defp html_footer do
    """
    <div style="display: inline-block">
    <a href="https://www.facebook.com/SafePet24" target="_blank"><img src="https://img.icons8.com/fluency/344/facebook-new.png" alt="facebook" style="width: 35px" /></a>
    <a href="https://www.instagram.com/safepet24" target="_blank"><img src="https://img.icons8.com/fluency/344/instagram-new.png" alt="instagram" style="width: 35px" /></a>
    </div>
    """
  end
end
