defmodule Erlef.Data.Repo.Migrations.AlterEventsAddEventType do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add(:event_type_id, references(:event_types))
    end
  end
end
