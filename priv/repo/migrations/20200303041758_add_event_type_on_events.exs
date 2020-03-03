defmodule Erlef.Data.Repo.Migrations.AddEventTypeOnEvents do
  use Ecto.Migration

  def change do
    alter table(:event_types) do
      remove :detail
    end

    alter table(:events) do
      add :event_type_id, references(:event_types, type: :uuid)
    end

  end
end
