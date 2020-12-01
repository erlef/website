defmodule ErlefWeb.WorkingGroupController do
  use ErlefWeb, :controller

  alias Erlef.{Blogs, Groups}

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    groups =
      Groups.all_working_groups()
      |> Enum.reject(fn wg -> wg.slug == "eef" end)
      |> sort_by_formation()

    render(conn, working_groups: groups)
  end

  def show(conn, %{"id" => slug}) do
    {:ok, wg} = Groups.get_working_group_by_slug(slug)

    render(conn,
      wg: wg,
      blog_posts: Blogs.get_posts_by_category(slug),
      topic: slug
    )
  end

  defp sort_by_formation(groups) do
    Enum.sort(groups, &(Date.compare(&1.formed, &2.formed) == :lt))
  end
end
