defmodule Erlef.Repo.Migrations.DropSlugOnEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do 
      remove :slug
    end
  end
end
