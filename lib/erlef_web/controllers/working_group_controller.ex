defmodule ErlefWeb.WorkingGroupController do
  use ErlefWeb, :controller
  alias Erlef.{Blog, Posts, WG}

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    groups =
      WG.all()
      |> Enum.reject(fn wg -> wg.slug == "eef" end)
      |> sort_by_formation()

    render(conn, working_groups: groups)
  end

  def show(conn, %{"id" => slug}) do
    case WG.fetch(slug) do
      nil ->
        {:error, :not_found}

      wg ->
        render(conn, wg: wg, blog_posts: fetch_blog_preview(slug), topic: slug)
    end
  end

  defp fetch_blog_preview(id) do
    Posts.get_by_category(Blog, id)
  end

  defp sort_by_formation(groups) do
    Enum.sort(groups, &(Date.compare(&1.formed, &2.formed) == :lt))
  end
end
