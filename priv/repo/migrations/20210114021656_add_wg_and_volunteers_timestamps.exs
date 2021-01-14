defmodule Erlef.Repo.Migrations.AddWgAndVolunteersTimestamps do
  use Ecto.Migration

  def change do
    for t <- ~w(volunteers working_groups working_group_volunteers working_group_chairs) do 
          
      alter table(t) do 
        add :inserted_at, :utc_datetime
        add :updated_at, :utc_datetime
      end

      execute """
              update #{t} set inserted_at = (now() at time zone 'utc'), updated_at = (now() at time zone 'utc')
              """
      alter table(t) do 
        modify :inserted_at, :utc_datetime, null: false
        modify :updated_at, :utc_datetime, null: false
      end
    end
  end
end
