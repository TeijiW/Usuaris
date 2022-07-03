defmodule Usuaris.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Usuaris.Repo,
      # Start the Telemetry supervisor
      UsuarisWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Usuaris.PubSub},
      # Start the Endpoint (http/https)
      UsuarisWeb.Endpoint
      # Start a worker by calling: Usuaris.Worker.start_link(arg)
      # {Usuaris.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Usuaris.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UsuarisWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
