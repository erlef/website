defmodule Erlef.Repo.Migrations.AddSubmittedByIdOnEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do 
      modify :approved_by, :uuid, null: true
      modify :submitted_by, :uuid, null: true
      add :approved_by_id, references(:members), null: true
      add :submitted_by_id, references(:members), null: true
    end

   execute("update events set approved_by_id = submitted_by")
   execute("update events set submitted_by_id = submitted_by")

  end
end
