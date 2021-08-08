defmodule Erlef.Repo.Migrations.CreateBlogPosts do
  use Ecto.Migration

  def change do
    create table(:blog_posts) do
      add :title, :string, null: false
      add :slug, :string, null: false
      add :body, :string, null: false
      add :status, :string, null: false
      add :member_id, references(:members, on_delete: :nothing)
      add :working_group_id, references(:working_groups, on_delete: :nothing)
      add :versions, :map
      timestamps()
    end

    create unique_index(:blog_posts, [:slug])
    create index(:blog_posts, [:member_id])
  end
end
