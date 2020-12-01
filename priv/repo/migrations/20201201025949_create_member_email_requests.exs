defmodule Erlef.Repo.Migrations.CreateMemberEmailRequests do
  use Ecto.Migration

  def change do
    create table(:member_email_requests) do
      add(:type, :string, null: false)
      add(:status, :string, null: false)
      add(:username, :string, null: false)
      add(:submitted_by, :uuid, null: false)
      add(:logs, :map)
      add(:assigned_to, :uuid)
      timestamps()
    end
  end
end
