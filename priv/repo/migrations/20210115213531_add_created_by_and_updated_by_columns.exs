defmodule Erlef.Repo.Migrations.AddCreatedByAndUpdatedByColumns do
  use Ecto.Migration

  def change do
    alter table(:working_groups) do 
      add :created_by, :uuid
      add :updated_by, :uuid
    end

    alter table(:volunteers) do 
      add :created_by, :uuid
      add :updated_by, :uuid
    end

  end
end
