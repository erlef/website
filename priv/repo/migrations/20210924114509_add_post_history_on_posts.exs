defmodule Erlef.Repo.Migrations.AddPostHistoryOnPosts do
  use Ecto.Migration

  def change do
    alter table(:blog_posts) do 
      add :post_versions, :map 
    end
  end
end
