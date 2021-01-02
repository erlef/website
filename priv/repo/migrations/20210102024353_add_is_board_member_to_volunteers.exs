defmodule Erlef.Repo.Migrations.AddIsBoardMemberToVolunteers do
  use Ecto.Migration

  def change do
    alter table(:volunteers) do 
      add :is_board_member, :boolean, default: false, null: false
    end
  end
end
