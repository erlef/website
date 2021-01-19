defmodule ErlefWeb.WorkingGroupController do
  use ErlefWeb, :controller

  alias Erlef.{Blogs, Groups}

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, working_groups: all_groups())
  end

  def show(conn, %{"id" => slug}), do: render_show(conn, slug)

  def edit(conn, %{"id" => slug}) do
        case Groups.get_working_group_by_slug(slug) do
          {:ok, wg} ->
            case is_chair(conn, wg) do
              true -> 
                changeset = Groups.change_working_group(wg)

                render(conn, "edit.html",
                wg: wg,
                changeset: changeset,
                is_chair: is_chair(conn, wg)
                )
              false ->
                redirect(conn, to: Routes.working_group_path(conn, :show, wg.slug))
            end

          {:error, :not_found} ->
            conn
            |> put_flash(:error, "Can't seem to find that group 🤔")
            |> redirect(to: Routes.working_group_path(conn, :index))
        end
  end

  def update(conn, %{"id" => slug, "working_group" => params}) do
    {:ok, wg} = Groups.get_working_group_by_slug(slug)
    case is_chair(conn, wg) do
      true ->
        case Groups.update_working_group(wg, params, audit: audit(conn)) do
          {:ok, wg} ->
            conn
            |> put_flash(:info, "Working group updated successfully.")
            |> redirect(to: Routes.working_group_path(conn, :show, wg.slug))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", wg: wg, changeset: changeset, is_chair: is_chair(conn, wg))
        end

      false ->
        redirect(conn, to: Routes.working_group_path(conn, :show, wg.slug))
    end
  end

  def calendar(conn, %{"slug" => slug}), do: render_show(conn, slug)

  defp render_show(conn, slug) do
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
