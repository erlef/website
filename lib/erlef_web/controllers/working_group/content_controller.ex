defmodule ErlefWeb.WorkingGroup.ContentController do
  use ErlefWeb, :controller

  plug :put_layout, :wg

  alias Erlef.{Blog, Groups}

  action_fallback ErlefWeb.FallbackController

  def show(conn, %{"slug" => slug, "page" => page}) do
    case Regex.match?(~r/^[a-zA-Z0-9_]+$/, page) do
      true ->
        wg = conn.assigns.current_working_group

        render(
          conn,
          "#{slug}-#{page}.html",
          wg: wg,
          blog_posts: Blog.get_posts_by_category(slug),
          topic: slug,
          is_chair: is_chair?(conn, wg)
        )

      false ->
        redirect(conn, to: Routes.working_group_path(conn, :show, slug))
    end
  end

  defp is_chair?(%{assigns: %{current_user: member}}, wg) do
    Groups.is_chair?(wg, member)
  end

  defp is_chair?(_, _wg), do: false
end
