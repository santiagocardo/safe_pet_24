defmodule SafePet24.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SafePet24.SerialsCache,
      # Start the Ecto repository
      SafePet24.Repo,
      # Start the Telemetry supervisor
      SafePet24Web.Telemetry,
      # Start the unconfirmed accounts process
      SafePet24.UnconfirmedAccounts,
      # Start the PubSub system
      {Phoenix.PubSub, name: SafePet24.PubSub},
      # Start the Endpoint (http/https)
      SafePet24Web.Endpoint
      # Start a worker by calling: SafePet24.Worker.start_link(arg)
      # {SafePet24.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SafePet24.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SafePet24Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
