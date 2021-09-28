defmodule Erlef.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, only: [from: 2]
  alias Erlef.Repo

  alias Erlef.Blog.Post
  alias Erlef.Accounts
  alias Erlef.Accounts.Member

  @spec list_blog_posts() :: [Post.t()]
  def list_blog_posts do
    Repo.all(published_posts_query())
  end

  @spec list_archived_blog_posts(Member.t()) :: {:ok, [Post.t()]} | {:error, :not_allowed_to_post}
  def list_archived_blog_posts(member) do
    case categories_allowed_to_post(member) do
      [] ->
        {:error, :not_allowed_to_post}

      categories ->
        query =
          from(p in Post,
            where: p.category in ^categories and p.status == :archived,
            order_by: [desc: p.published_at]
          )

        {:ok, Repo.all(query)}
    end
  end

  @spec get_posts_by_category(String.t()) :: [Post.t()]
  def get_posts_by_category(category) do
    query =
      from(published_posts_query(),
        where: [category: ^category]
      )

    Repo.all(query)
  end

  @spec get_posts_by_tag(String.t()) :: [Post.t()]
  def get_posts_by_tag(tag) do
    query =
      from(p in published_posts_query(),
        where: ^tag in p.tags
      )

    Repo.all(query)
  end

  @spec get_post_by_slug!(String.t()) :: Post.t()
  def get_post_by_slug!(slug) do
    Repo.one!(from(Post, where: [slug: ^slug]))
  end

  @spec get_post_by_slug(String.t()) :: {:ok, Post.t()} | {:error, :not_found}
  def get_post_by_slug(slug) do
    query = from(Post, where: [slug: ^slug])

    case Repo.one(query) do
      %Post{} = post -> {:ok, post}
      _ -> {:error, :not_found}
    end
  end

  @spec latest_posts() :: [Post.t()]
  def latest_posts() do
    query =
      from(published_posts_query(),
        limit: 3
      )

    Repo.all(query)
  end

  @spec all_tags() :: [String.t()]
  def all_tags() do
    query =
      from(Post,
        where: [status: :published],
        select: [:tags]
      )

    Repo.all(query)
    |> Enum.flat_map(& &1.tags)
    |> Enum.uniq()
    |> Enum.sort(&(byte_size(&1) <= byte_size(&2)))
  end

  @spec create_post(map()) :: {:ok, Post.t()} | {:error, Ecto.Changeset.t()}
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_post(Post.t(), map()) :: {:ok, Post.t()} | {:error, Ecto.Changeset.t()}
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @spec change_post(Post.t(), map()) :: Ecto.Changeset.t()
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  @spec categories_allowed_to_post(Member.t() | Ecto.UUID.t()) :: [String.t()]
  def categories_allowed_to_post(member_id) when is_binary(member_id) do
    categories_allowed_to_post(Accounts.get_member!(member_id))
  end

  def categories_allowed_to_post(%{is_app_admin: true}) do
    ["eef", "newsletter"] ++ wg_categories(Erlef.Groups.list_working_groups())
  end

  def categories_allowed_to_post(%{membership_level: :board} = member) do
    ["eef", "newsletter"] ++ maybe_wg_categories(member)
  end

  def categories_allowed_to_post(member), do: maybe_wg_categories(member)

  defp maybe_wg_categories(member) do
    case Erlef.Groups.get_volunteer_by_member_id(member.id) do
      %Erlef.Groups.Volunteer{working_groups: working_groups} ->
        wg_categories(working_groups)

      _ ->
        []
    end
  end

  defp wg_categories(working_groups) do
    Enum.map(working_groups, fn wg -> wg.slug end)
  end

  defp published_posts_query() do
    from(Post,
      order_by: [desc: :published_at],
      where: [status: :published]
    )
  end
end
