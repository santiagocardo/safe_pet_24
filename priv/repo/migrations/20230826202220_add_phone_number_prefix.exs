defmodule SafePet24.Repo.Migrations.AddPhoneNumberPrefix do
  use Ecto.Migration

  import Ecto.Query

  def up do
    from(c in SafePet24.Contacts.Contact)
    |> update([c], set: [phone: fragment("concat('+57', ?)", c.phone)])
    |> SafePet24.Repo.update_all([])
  end

  def down do
    # Nothing to do here
  end
end
