defmodule Erlef.Repo.Migrations.AddSponsorIdToMembers do
  use Ecto.Migration

  def change do
    alter table(:members) do
      add :sponsor_id, references(:sponsors)
    end

    create index(:members, [:sponsor_id])
  end
end
