defmodule ErlefWeb.WorkingGroupController do
  use ErlefWeb, :controller

  alias Erlef.{Blogs, Groups}

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, working_groups: all_groups())
  end

  def show(conn, %{"id" => slug}) do
    case Groups.get_working_group_by_slug(slug) do
      {:ok, wg} ->
        render(conn,
          wg: wg,
          blog_posts: Blogs.get_posts_by_category(slug),
          topic: slug,
          is_chair: is_chair(conn, wg)
        )

      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Can't seem to find that group 🤔")
        |> redirect(to: Routes.working_group_path(conn, :index))
    end
  end

  defp is_chair(%{assigns: %{current_user: member}}, wg) do
    Groups.is_chair?(wg, member)
  end

  defp all_groups() do
    Groups.list_working_groups()
    |> Enum.reject(fn wg -> wg.slug == "eef" end)
    |> sort_by_formation()
  end

  defp sort_by_formation(groups) do
    Enum.sort(groups, &(Date.compare(&1.formed, &2.formed) == :lt))
  end
end
