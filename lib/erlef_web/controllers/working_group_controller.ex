defmodule ErlefWeb.WorkingGroupController do
  use ErlefWeb, :controller

  alias Erlef.{Blogs, Groups}

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, working_groups: all_groups())
  end

  def show(conn, %{"id" => slug}), do: render_show(conn, slug)

  def edit(conn, %{"id" => slug}) do
    with {:ok, wg} <- Groups.get_working_group_by_slug(slug),
         {:is_chair, true} <- {:is_chair, is_chair(conn, wg)} do
      render(conn, "edit.html",
        wg: wg,
        changeset: Groups.change_working_group(wg),
        is_chair: is_chair(conn, wg)
      )
    else
      {:is_chair, false} ->
        redirect(conn, to: Routes.working_group_path(conn, :show, slug))

      {:error, :not_found} ->
        not_found(conn)
    end
  end

  def update(conn, %{"id" => slug, "working_group" => params}) do
    with {:ok, wg} <- Groups.get_working_group_by_slug(slug),
         {:is_chair, true} <- {:is_chair, is_chair(conn, wg)},
         {:ok, wg} <- Groups.update_working_group(wg, params, audit: audit(conn)) do
      conn
      |> put_flash(:info, "Working group updated successfully.")
      |> redirect(to: Routes.working_group_path(conn, :show, wg.slug))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          wg: changeset.data,
          changeset: changeset,
          is_chair: is_chair(conn, changeset.data)
        )

      {:error, :not_found} ->
        not_found(conn)

      {:is_chair, false} ->
        redirect(conn, to: Routes.working_group_path(conn, :show, slug))
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
        not_found(conn)
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

  defp not_found(conn) do
    conn
    |> put_flash(:error, "Can't seem to find that group 🤔")
    |> redirect(to: Routes.working_group_path(conn, :index))
  end

  defp sort_by_formation(groups) do
    Enum.sort(groups, &(Date.compare(&1.formed, &2.formed) == :lt))
  end
end
