defmodule ErlefWeb.WorkingGroupController do
  use ErlefWeb, :controller
  alias Erlef.Blogs.Repo
  alias Erlef.{Members, WG}

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
        members = Enum.shuffle(Members.roster(slug))
        render(conn, wg: wg, blog_posts: fetch_blog_preview(slug), members: members, topic: slug)
    end
  end

  defp fetch_blog_preview(id) do
    id
    |> Repo.for_wg()
  end

  defp sort_by_formation(groups) do
    Enum.sort(groups, &(Date.compare(&1.formed, &2.formed) == :lt))
  end
end
