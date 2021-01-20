defmodule Erlef.Repo.Migrations.AddMemberIdOnWorkingGroupReports do
  use Ecto.Migration

  def change do
    alter table(:working_group_reports) do 
      add :member_id, :uuid, null: false
    end
  end
end
