defmodule Erlef.Blog.Post do
  @moduledoc """
  Schema for blog posts.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "blog_posts" do
    field(:body, :string)
    field(:slug, :string)
    field(:status, Ecto.Enum, values: [:draft, :published, :archived])
    field(:title, :string)
    field(:member_id, :id)
    field(:working_group_id, :id)

    many_to_many(:blog_tags, Erlef.Blog.Tag, join_through: "blog_posts_blog_tags")
    embeds_many(:versions, Erlef.Blog.Version, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :slug, :body, :status])
    |> validate_required([:title, :slug, :body, :status])
    |> unique_constraint(:slug)
  end
end
