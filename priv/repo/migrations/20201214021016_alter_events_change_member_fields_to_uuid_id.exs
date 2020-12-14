defmodule Erlef.Repo.Migrations.AlterEventsMigrateMemberFieldToUUID do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify :approved_by, :integer, null: true
      modify :submitted_by, :integer, null: true
      add :old_approved_by, :integer
      add :old_submitted_by, :integer
    end

    execute("UPDATE events SET old_approved_by = approved_by, old_submitted_by = submitted_by")
    execute("UPDATE events SET approved_by = null, submitted_by = null")

    alter table(:events) do 
      remove :approved_by
      remove :submitted_by
    end

    alter table(:events) do 
      add :approved_by, :uuid
      add :submitted_by, :uuid
    end

  end
end
