defmodule Erlef.Repo.Migrations.CreateJobPosts do
  use Ecto.Migration

  def change do
    create table(:job_posts) do
      add :title, :string, null: false
      add :description, :text, null: false
      add :position_type, :string, null: false
      add :approved, :boolean, null: false, default: false
      add :city, :string
      add :region, :string
      add :country, :string
      add :postal_code, :string
      add :remote, :boolean, null: false
      # There's no standard limit on URI length so `text` is more appropriate
      # than `string`.
      add :website, :text
      add :ttl, :interval, null: false, default: "30 days"
      add :created_by, references(:members), null: false

      timestamps()
    end

    execute(&create_expired_at_column/0, &drop_expired_at_column/0)

    create index(:job_posts, [:created_by])
  end

  defp create_expired_at_column() do
    query = """
    ALTER TABLE job_posts
      ADD expired_at timestamptz
        GENERATED ALWAYS AS (inserted_at + ttl) STORED;
    """

    repo().query!(query)
  end

  defp drop_expired_at_column() do
    repo().query!("ALTER TABLE job_posts DROP COLUMN expired_at")
  end
end
