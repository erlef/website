defmodule Erlef.Repo.Migrations.AddCharterHistoryOnWorkingGroups do
  use Ecto.Migration

  def change do
    alter table(:working_groups) do 
      add :charter_versions, :map 
    end
  end
end
