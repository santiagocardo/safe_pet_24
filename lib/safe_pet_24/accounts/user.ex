defmodule SafePet24.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :serial, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime
    field :name, :string, virtual: true
    field :phone, :string, virtual: true

    has_many :pets, SafePet24.Pets.Pet
    has_many :contacts, SafePet24.Contacts.Contact

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :password, :serial, :name, :phone])
    |> validate_serial()
    |> validate_email()
    |> validate_password(opts)
    |> validate_required([:name, :phone])
    |> validate_length(:name, min: 4, max: 40)
    |> validate_length(:phone, is: 10)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/,
      message: "debe tener el signo @ y sin espacios"
    )
    |> validate_length(:email, max: 80)
    |> unsafe_validate_unique(:email, SafePet24.Repo, message: "ya está en uso")
    |> unique_constraint(:email, message: "ya está en uso")
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    |> validate_format(:password, ~r/[a-z]/, message: "al menos un carácter debe ir en minúscula")
    |> validate_format(:password, ~r/[A-Z]/, message: "al menos un carácter debe ir en mayúscula")
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "al menos un dígito o carácter de puntuación"
    )
    |> maybe_hash_password(opts)
  end

  defp validate_serial(changeset) do
    changeset
    |> validate_required([:serial])
    |> validate_length(:serial, min: 6, max: 24)
    |> unsafe_validate_unique(:serial, SafePet24.Repo, message: "ya está en uso")
    |> unique_constraint(:serial, message: "ya está en uso")
    |> validate_change(:serial, fn :serial, serial ->
      serials = SafePet24.SerialsCache.get()

      if serial in serials, do: [], else: [serial: "serial no válido"]
    end)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "no hay cambio")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "no coincide con la contraseña")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%SafePet24.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "no es válido")
    end
  end
end
