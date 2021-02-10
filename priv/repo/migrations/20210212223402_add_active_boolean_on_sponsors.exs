defmodule Erlef.Repo.Migrations.AddActiveBooleanOnSponsors do
  use Ecto.Migration

  def change do
    alter table(:sponsors) do
      add :active, :boolean, default: true
    end

    execute("update sponsors set active = false where name = 'genetec'")
  end
end
