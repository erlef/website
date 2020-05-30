defmodule Erlef.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      Erlef.Repo,
      Erlef.Repo.Importer,
      Erlef.Data.Repo,
      {Phoenix.PubSub, name: Erlef.PubSub},
      ErlefWeb.Endpoint,
      {PlugAttack.Storage.Ets, name: MyApp.PlugAttack.Storage, clean_period: 60_000}
      # Starts a worker by calling: Erlef.Worker.start_link(arg)
      # {Erlef.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Erlef.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ErlefWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
