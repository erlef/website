defmodule Erlef.Release do
  @moduledoc """
  Erlef.Release - release tasks for Erlef app
  """

  def seed do
    load_app()
    priv_dir = :code.priv_dir(:erlef) |> List.to_string()
    seeds = priv_dir <> "/repo/seeds.exs"
    Code.require_file(seeds)
  end

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(:erlef, :ecto_repos)
  end

  defp load_app do
    Application.load(:erlef)
    Enum.each([:logger, :ssl, :postgrex, :ecto, :ecto_sql], &Application.ensure_all_started/1)
  end
end
