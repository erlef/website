defmodule Erlef.Repo.Migrations.AddActiveBooleanOnWorkingGroups do
  use Ecto.Migration

  def change do
    alter table(:working_groups) do 
      add :active, :boolean, default: true, null: false
    end

    create index("working_groups", [:active])
  end
end
