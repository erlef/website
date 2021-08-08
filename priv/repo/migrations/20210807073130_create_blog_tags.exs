defmodule Erlef.Repo.Migrations.CreateBlogTags do
  use Ecto.Migration

  def change do
    create table(:blog_tags) do
      add :name, :string, null: false
      add :slug, :string, null: false
    end

  end
end
