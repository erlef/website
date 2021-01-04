defmodule Erlef.Repo.Migrations.AddCreatedByAndUpdatedByOnSponsors do
  use Ecto.Migration

  def change do
    alter table(:sponsors) do 
      add :created_by, :uuid
      add :updated_by, :uuid
    end
  end
end
