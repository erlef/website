defmodule Erlef.Blog.Tag do
  @moduledoc """
  Schema for blog tags.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "blog_tags" do
    field(:name, :string)
    field(:slug, :string)
    many_to_many(:blog_posts, Erlef.Blog.Post, join_through: "blog_posts_blog_tags")
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
  end
end
