defmodule Erlef.Repo.Migrations.CreateObanJobs do
  use Ecto.Migration

  def up do
    Oban.Migrations.up(version: 11)
  end

  def down do
    Oban.Migrations.down(version: 1)
  end
end
