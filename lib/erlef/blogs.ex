defmodule Erlef.Blogs do
  @moduledoc """
  Erlef.Blogs context
  """

  import Ecto.Query
  alias Erlef.Repo.ETS
  alias Erlef.Blogs.Post

  @spec get_posts_by_tag(String.t()) :: [Post.t()]
  def get_posts_by_tag(tag) do
    all_posts()
    |> Enum.filter(fn p -> tag in p.tags end)
    |> sort_posts_by_datetime()
  end

  @spec latest_posts() :: [Post.t()]
  def latest_posts() do
    all_posts()
    |> sort_posts_by_datetime()
    |> Enum.take(3)
  end

  # Sorts from smallest to largest
  @spec all_tags() :: [String.t()]
  @doc """
  Fetch and sort all available blog tags from smallest to largest byte size
  """
  def all_tags() do
    Post
    |> ETS.all()
    |> Enum.flat_map(& &1.tags)
    |> Enum.uniq()
    |> Enum.sort(&(byte_size(&1) <= byte_size(&2)))
  end

  @spec all_posts() :: [Post.t()]
  def all_posts() do
    Post |> ETS.all()
  end

  @spec get_post_by_slug(String.t()) :: {:ok, Post.t()} | {:error, :not_found}
  def get_post_by_slug(slug) do
    case ETS.get_by(Post, slug: slug) do
      %{slug: ^slug} = post -> {:ok, post}
      _ -> {:error, :not_found}
    end
  end

  @spec get_posts_by_category(String.t()) :: [Post.t()]
  def get_posts_by_category(cat) do
    Post |> where([x], x.category == ^cat) |> ETS.all()
  end

  @spec sort_posts_by_datetime([Post.t()]) :: [Post.t()]
  def sort_posts_by_datetime(posts) do
    Enum.sort(
      posts,
      fn p1, p2 ->
        DateTime.compare(p1.datetime, p2.datetime) == :gt
      end
    )
  end
end
