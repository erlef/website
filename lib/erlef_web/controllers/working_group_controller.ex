defmodule ErlefWeb.WorkingGroupController do
  use ErlefWeb, :controller

  plug :put_layout, :wg

  alias Erlef.{Blog, Groups}

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    conn
    |> put_layout(:app)
    |> render(working_groups: all_groups())
  end

  def show(conn, %{"slug" => slug}), do: render_show(conn, slug)

  def calendar(conn, %{"slug" => slug}), do: render_show(conn, slug)

  defp render_show(conn, slug) do
    case Groups.get_working_group_by_slug(slug) do
      {:ok, wg} ->
        render(conn,
          wg: wg,
          blog_posts: Blog.get_posts_by_category(slug),
          topic: slug,
          is_volunteer: is_volunteer(conn, wg),
          is_chair: is_chair(conn, wg)
        )

      {:error, :not_found} ->
        not_found(conn)
    end
  end

  defp all_groups() do
    Groups.list_working_groups()
    |> Enum.reject(fn wg -> wg.slug == "eef" end)
    |> sort_by_formation()
  end

  defp is_volunteer(%{assigns: %{current_user: member}}, wg) do
    Groups.is_volunteer?(wg, member)
  end

  defp is_chair(%{assigns: %{current_user: member}}, wg) do
    Groups.is_chair?(wg, member)
  end

  defp not_found(conn) do
    conn
    |> put_flash(:error, "Can't seem to find that group 🤔")
    |> redirect(to: Routes.working_group_path(conn, :index))
  end

  defp sort_by_formation(groups) do
    Enum.sort(groups, &(Date.compare(&1.formed, &2.formed) == :lt))
  end
end
