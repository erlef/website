defmodule Erlef.Repo.Migrations.CreateBlogPosts do
  use Ecto.Migration

  def change do
    create table(:blog_posts) do
      add :title, :string
      add :slug, :string
      add :excerpt, :string
      add :body, :text
      add :authors, {:array, :string}
      add :category, :string
      add :tags, {:array, :string}
      add :status, :string
      add :published_at, :utc_datetime
      add :owner_id, references(:members, on_delete: :nothing)

      timestamps()
    end

    create index(:blog_posts, [:owner_id])
  end
end
