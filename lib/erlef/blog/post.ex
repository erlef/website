defmodule Erlef.Blog.Post do
  @moduledoc """
  Schema for blog posts.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "blog_posts" do
    field(:title, :string)
    field(:slug, :string)
    field(:body, :string)
    field(:status, Ecto.Enum, values: [:draft, :published, :archived])

    field(:member_id, :id)
    field(:working_group_id, :id)

    many_to_many(:blog_tags, Erlef.Blog.Tag, join_through: "blog_posts_blog_tags")
    embeds_many(:versions, Erlef.Blog.Version, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :status, :member_id, :working_group_id])
    |> validate_required([:title, :body, :status, :member_id])
    |> slug_from_title()
  end

  defp slug_from_title(%{changes: %{title: title}} = changeset) do
    put_change(changeset, :slug, Slug.slugify(title))
  end

  defp slug_from_title(cs), do: cs
end
