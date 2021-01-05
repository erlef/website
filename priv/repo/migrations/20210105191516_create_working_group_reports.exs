defmodule Erlef.Repo.Migrations.CreateWorkingGroupReports do
  use Ecto.Migration

  def change do
    create table(:working_group_reports) do
      add :type, :string, null: false
      add :content, :text, null: false
      add :is_private, :boolean, default: true, null: false
      add :meta, :map, default: %{}, null: false
      add :submitted_by_id, references(:volunteers, on_delete: :nothing)
      add :working_group_id, references(:working_groups, on_delete: :nothing)

      timestamps()
    end

    create index(:working_group_reports, [:submitted_by_id])
    create index(:working_group_reports, [:working_group_id])
  end
end
