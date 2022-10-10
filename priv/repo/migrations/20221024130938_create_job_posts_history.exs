defmodule Erlef.Repo.Migrations.CreateJobPostsHistory do
  use Ecto.Migration

  def change do
    create table(:job_posts_history, primary_key: false) do
      add :hid, :uuid, primary_key: true
      add :id, references(:job_posts), null: false
      add :title, :string
      add :description, :text
      add :position_type, :string
      add :approved, :boolean
      add :city, :string
      add :region, :string
      add :country, :string
      add :postal_code, :string
      add :remote, :boolean
      add :website, :text
      add :ttl, :interval

      add :created_by, :uuid, null: false
      add :deleted_by, :uuid
      add :created_at, :timestamptz, null: false, default: fragment("current_timestamp")
      add :deleted_at, :timestamptz
    end

    execute(&create_valid_range_column/0, &drop_valid_range_column/0)

    create index(:job_posts_history, [:id])
    create index(:job_posts_history, [:valid_range], using: "GIST")
  end

  defp create_valid_range_column() do
    query = """
    ALTER TABLE job_posts_history
      ADD valid_range tstzrange
        GENERATED ALWAYS AS (tstzrange(created_at, deleted_at)) STORED;
    """

    repo().query!(query)
  end

  defp drop_valid_range_column() do
    repo().query!("ALTER TABLE job_posts_history DROP COLUMN valid_range")
  end
end
