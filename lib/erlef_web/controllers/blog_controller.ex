defmodule ErlefWeb.BlogController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Blogs
  alias Erlef.Groups

  def index(conn, %{"topic" => topic}) do
    case fetch_working_group(String.downcase(topic)) do
      {:error, _} = err ->
        err

      {:ok, wg} ->
        render(conn, "index.html",
          topic: topic,
          name: wg.name,
          description: wg.description,
          posts: list(topic)
        )
    end
  end

  def index(conn, _params) do
    descrip = "Find all the related news of the Erlang Ecosystem Foundation"

    render(conn, "index.html", topic: "eef", name: "EEF", description: descrip, posts: list("eef"))
  end

  def show(conn, %{"id" => id}) do
    case get(id) do
      {:ok, post} ->
        wg =
          case post.category do
            cat when cat in ["eef", "newsletter"] ->
              nil

            _ ->
              {:ok, wg} = fetch_working_group(post)
              wg
          end

        render(conn, "show.html",
          slug: id,
          post: post,
          all_tags: Blogs.all_tags(),
          working_group: wg,
          latest_news: Blogs.latest_posts()
        )

      _ ->
        {:error, :not_found}
    end
  end

  def tags(conn, %{"tag" => tag}) do
    render(conn, "tags.html",
      tag: tag,
      posts: Blogs.get_posts_by_tag(tag),
      latest_posts: Blogs.latest_posts(),
      all_tags: Blogs.all_tags()
    )
  end

  defp get(id), do: Blogs.get_post_by_slug(id)

  defp fetch_working_group(%{category: slug}) when not is_nil(slug) do
    Groups.get_working_group_by_slug(slug)
  end

  defp fetch_working_group(name) when is_bitstring(name),
    do: Groups.get_working_group_by_slug(name)

  defp fetch_working_group(_), do: nil

  def list("eef"), do: Blogs.all_posts() |> Blogs.sort_posts_by_datetime()
  def list(name) when not is_nil(name), do: Blogs.get_posts_by_category(name)
  def list(_), do: []
end
