defmodule SafePet24Web.LayoutView do
  use SafePet24Web, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def total_pets, do: SafePet24.Pets.total_pets()
  def total_contacts, do: SafePet24.Contacts.total_contacts()
end
