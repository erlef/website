defmodule Erlef.Data.Repo.Migrations.SetEventTypeOnEventsNonNullable do
  use Ecto.Migration

  def change do
    drop(constraint("events", "events_event_type_id_fkey"))
    alter table(:events) do
      modify :event_type_id, references(:event_types), null: false
    end
  end
end
