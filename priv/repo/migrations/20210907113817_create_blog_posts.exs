defmodule Erlef.Repo.Migrations.CreateBlogPosts do
  use Ecto.Migration

  def change do
    create table(:blog_posts) do
      add :title, :string, null: false
      add :slug, :string, null: false
      add :excerpt, :string
      add :body, :text, null: false
      add :authors, {:array, :string}, null: false
      add :category, :string, null: false
      add :tags, {:array, :string}, null: false
      add :status, :string, null: false
      add :published_at, :utc_datetime
      add :owner_id, references(:members, on_delete: :nothing)
      add :post_versions, :map 

      timestamps()
    end

    create index(:blog_posts, [:owner_id])
    create unique_index(:blog_posts, [:slug])
  end
end
