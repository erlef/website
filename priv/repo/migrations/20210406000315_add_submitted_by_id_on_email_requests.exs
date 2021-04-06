defmodule Erlef.Repo.Migrations.AddSubmittedByIdOnEmailRequests do
  use Ecto.Migration

  def change do
    alter table(:member_email_requests) do 
      modify :assigned_to, :uuid, null: true
      modify :submitted_by, :uuid, null: true
      add :assigned_to_id, references(:members), null: true
      add :submitted_by_id, references(:members), null: true
    end

   execute("update member_email_requests set assigned_to_id = submitted_by")
   execute("update member_email_requests set submitted_by_id = submitted_by")

  end
end
