defmodule Erlef.Repo.Migrations.AddSlackInviteRequestBooleanOnMembers do
  use Ecto.Migration

  def change do
    alter table(:members) do 
      add :has_requested_slack_invite, :boolean, default: false, null: false
      add :requested_slack_invite_at, :utc_datetime
    end
  end
end
