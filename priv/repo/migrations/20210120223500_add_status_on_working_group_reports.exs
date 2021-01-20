defmodule Erlef.Repo.Migrations.AddStatusOnWorkingGroupReports do
  use Ecto.Migration

  def change do
    alter table(:working_group_reports) do
      add :status, :string, null: false
    end
  end
end
