defmodule Erlef.Repo.Migrations.DropEventTypes do
  use Ecto.Migration

  def change do
    alter table(:events) do 
      remove(:event_type_id)
    end

    drop table(:event_types)
  end
end
