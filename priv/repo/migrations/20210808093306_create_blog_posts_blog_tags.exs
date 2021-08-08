defmodule Erlef.Repo.Migrations.CreateBlogPostsBlogTags do
  use Ecto.Migration

  def change do
    create table(:blog_posts_blog_tags) do
      add :blog_post_id, references(:blog_posts)
      add :blog_tag_id, references(:blog_tags)
    end

    create unique_index(:blog_posts_blog_tags, [:blog_post_id, :blog_tag_id])
  end
end
