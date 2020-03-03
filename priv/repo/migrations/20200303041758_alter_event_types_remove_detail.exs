defmodule Erlef.Data.Repo.Migrations.AlterEventTypesRemoveDetail do
  use Ecto.Migration

  def change do
    alter table(:event_types) do
      remove :detail
    end
  end
end
