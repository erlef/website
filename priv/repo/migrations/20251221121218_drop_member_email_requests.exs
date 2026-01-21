defmodule Erlef.Repo.Migrations.DropMemberEmailRequests do
  use Ecto.Migration

  def change do
    drop table(:member_email_requests)
  end
end
