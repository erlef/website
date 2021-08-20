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
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> slug_from_name()
    |> unique_constraint(:slug)
  end

  defp slug_from_name(%{changes: %{name: name}} = changeset) do
    put_change(changeset, :slug, Slug.slugify(name))
  end

  defp slug_from_name(cs), do: cs
end
