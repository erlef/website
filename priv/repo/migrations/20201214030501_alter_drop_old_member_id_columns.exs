defmodule Erlef.Repo.Migrations.AlterDropOldMemberIdColumns do
  use Ecto.Migration

  def change do
    alter table(:events) do 
      modify :submitted_by, :uuid, null: false
      remove :old_approved_by
      remove :old_submitted_by
    end
  end
end
