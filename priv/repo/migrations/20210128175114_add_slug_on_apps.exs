defmodule Erlef.Repo.Migrations.AddSlugOnApps do
  use Ecto.Migration

  def change do
    alter table(:apps) do 
      add :slug, :string, null: false
    end
  end
end
