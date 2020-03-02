defmodule ErlefWeb.WorkingGroupController do
  use ErlefWeb, :controller

  alias Erlef.{Blog, Posts, WorkingGroup}

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    groups =
      Posts.all(WorkingGroup)
      |> Enum.reject(fn wg -> wg.slug == "eef" end)
      |> sort_by_formation()

    render(conn, working_groups: groups)
  end

  def show(conn, %{"id" => slug}) do
    {:ok, wg} = Posts.get_by_slug(WorkingGroup, slug)

    render(conn,
      wg: wg,
      blog_posts: Posts.get_by_category(Blog, slug),
      topic: slug
    )
  end

  defp sort_by_formation(groups) do
    Enum.sort(groups, &(Date.compare(&1.formed, &2.formed) == :lt))
  end
end
