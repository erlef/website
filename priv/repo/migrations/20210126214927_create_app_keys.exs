defmodule Erlef.Repo.Migrations.CreateAppKeys do
  use Ecto.Migration

  def change do
    create table(:app_keys) do 
      add :app_id, references(:apps), null: false
      add :name, :string, null: false
      add :type, :string, null: false
      add :key_id, :string, null: false
      add :secret, :string, null: false
      add :last_used, :map
      add :revoked_at, :utc_datetime
      add :revoked_by, :uuid
      add :created_by, :uuid, null: false
      timestamps() 
    end

    create unique_index("app_keys", [:app_id, :name])
    create unique_index("app_keys", [:key_id])
    create unique_index("app_keys", [:secret])
  end
end
