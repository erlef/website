defmodule Erlef.Repo.Migrations.RemoveIsChairFromWorkingGroupVolunteers do
  use Ecto.Migration

  def change do
    alter table(:working_group_volunteers) do 
      remove :is_chair
    end

  end
end
