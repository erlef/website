defmodule Erlef.Repo.Migrations.AddTypeToEvents do
  use Ecto.Migration

  def change do
    drop constraint("events", "events_event_type_id_fkey")
    alter table(:events) do 
      modify(:event_type_id, references(:event_types), null: true)
      add(:type, :string)
    end
  end
end
