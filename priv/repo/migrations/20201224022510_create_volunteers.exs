defmodule Erlef.Repo.Migrations.CreateVolunteers do
  use Ecto.Migration

  def change do
    create table(:volunteers) do 
      add :member_id, :uuid
      add :name, :string, null: false
      add :avatar_url, :string
    end

    create unique_index("volunteers", [:name])
    create unique_index("volunteers", [:member_id])
    create unique_index("volunteers", [:avatar_url])
  end
end
