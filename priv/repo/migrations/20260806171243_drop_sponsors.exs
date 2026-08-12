defmodule Erlef.Repo.Migrations.DropSponsors do
  use Ecto.Migration

  def up do
    drop table(:sponsors)
  end

  def down, do: :ok
end
