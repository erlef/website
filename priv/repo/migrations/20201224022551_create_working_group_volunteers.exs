defmodule Erlef.Repo.Migrations.CreateWorkingGroupVolunteers do
  use Ecto.Migration

  def change do
    create table(:working_group_volunteers) do 
      add :working_group_id, references(:working_groups), null: false
      add :volunteer_id, references(:volunteers), null: false
      add :is_chair, :boolean, null: false, default: false
    end

    create unique_index("working_group_volunteers", [:working_group_id, :volunteer_id])
  end
end
