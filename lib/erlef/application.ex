defmodule Erlef.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    # children =
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    env = Application.get_env(:erlef, :env)
    opts = [strategy: :one_for_one, name: Erlef.Supervisor]
    Supervisor.start_link(children(env), opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ErlefWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp children(env) do
    children_for(env)
  end

  defp base_children() do
    [
      Erlef.Repo,
      Erlef.Repo.ETS,
      Erlef.Repo.ETS.Importer,
      ErlefWeb.Telemetry,
      {Phoenix.PubSub, name: Erlef.PubSub},
      ErlefWeb.Endpoint,
      {PlugAttack.Storage.Ets, name: Erlef.PlugAttack.Storage, clean_period: 60_000}
    ]
  end

  # The WildApricot model and cache server must be started first in dev/test
  defp children_for(env) when env in [:dev, :test] do
    base = [Erlef.Test.WildApricot, Erlef.WildApricot.Cache, Erlef.Test.S3] ++ base_children()

    case env do
      :dev ->
        # Agenda must be started after the repo, but only in dev
        base ++ [Erlef.Agenda]

      :test ->
        Enum.reject(base, fn c -> c == Erlef.Repo.ETS.Importer end)
    end
  end

  # The WildApricot Cache server should be started last when not in dev/test
  defp children_for(_), do: base_children() ++ [Erlef.WildApricot.Cache, Erlef.Agenda]
end
