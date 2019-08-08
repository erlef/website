defmodule ErlefWeb.WorkingGroupController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    groups =
      Erlef.WG.all()
      |> sort_by_formation()

    render(conn, working_groups: groups)
  end

  def show(conn, %{"id" => slug}) do
    case Erlef.WG.fetch(slug) do
      nil -> {:error, :not_found}
      wg -> render(conn, wg: wg, blog_posts: fetch_blog_preview(slug), topic: slug)
    end
  end

  defp fetch_blog_preview(id) do
    id
    |> Erlef.Blogs.Repo.for_wg()
  end

  defp sort_by_formation(groups) do
    Enum.sort(groups, &(Date.compare(&1.formed, &2.formed) == :lt))
  end
end
