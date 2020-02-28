defmodule Erlef.Data.Repo.Migrations.CreateEventTypes do
  use Ecto.Migration

  def change do
    create table(:event_types) do
      add :name, :string, null: false
      add :detail, :string, null: false
    end

    create(unique_index("event_types", [:name]))
  end
end
