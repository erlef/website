defmodule Erlef.Repo.Migrations.CreateApps do
  use Ecto.Migration

  def change do
    create table(:apps) do
      add :name, :string, null: false
      add :client_id, :uuid, null: false
      add :enabled, :boolean, null: false, default: false
      add :created_by, :uuid, null: false
      add :updated_by, :uuid, null: false
      timestamps()
    end

    create unique_index("apps", [:name])
  end
end
