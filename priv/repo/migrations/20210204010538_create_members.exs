defmodule Erlef.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do 
      add :avatar_url, :string
      add :name, :text, null: false
      add :email, :string, null: false
      add :erlef_email_address, :string
      add :roles, :map, null: false
      add :has_email_box, :boolean, null: false
      add :has_email_alias, :boolean, null: false
      add :has_email_address, :boolean, null: false
      add :is_app_admin, :boolean, null: false
      add :is_archived, :boolean, null: false
      add :is_donor, :boolean, null: false
      add :last_login_date, :date
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :member_since, :date, null: false
      add :membership_enabled, :boolean, null: false
      add :membership_level, :map, null: false
      add :suspended_member, :boolean, null: false
      add :terms_of_use_accepted, :boolean, null: false
      add :external, :map, null: false
      add :deactivated_at, :utc_datetime
      timestamps()
    end
  end
end
