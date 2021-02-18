defmodule ErlefWeb.Admin.WorkingGroupController do
  use ErlefWeb, :controller

  alias Erlef.Groups
  alias Erlef.Groups.WorkingGroup

  def index(conn, _params) do
    working_groups = Groups.list_working_groups()
    render(conn, "index.html", working_groups: working_groups)
  end

  def show(conn, %{"id" => id}) do
    working_group = Groups.get_working_group!(id)
    render(conn, "show.html", working_group: working_group)
  end

  def edit(conn, %{"id" => id}) do
    working_group = Groups.get_working_group!(id)
    changeset = Groups.change_working_group(working_group)
    render(conn, "edit.html", working_group: working_group, changeset: changeset)
  end

  def update(conn, %{"id" => id, "working_group" => params}) do
    working_group = Groups.get_working_group!(id)

    case Groups.update_working_group(working_group, params, audit: audit(conn)) do
      {:ok, working_group} ->
        conn
        |> put_flash(:info, "working_group updated successfully.")
        |> redirect(to: redirect_path(conn, working_group))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", working_group: working_group, changeset: changeset)
    end
  end

  def create_chair(conn, %{"id" => id, "volunteer_id" => vid}) do
    wg = Groups.get_working_group!(id)
    v = Groups.get_volunteer!(vid)

    case Groups.create_wg_chair(wg, v, audit: audit(conn)) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Successfully assigned volunteer as chair.")
        |> redirect(to: Routes.admin_working_group_path(conn, :show, wg.id))

      _err ->
        conn
        |> put_flash(:error, "Error assigning volunteer as chair.")
        |> redirect(to: Routes.admin_working_group_path(conn, :show, wg.id))
    end
  end

  def delete_chair(conn, %{"id" => id, "volunteer_id" => vid}) do
    wg = Groups.get_working_group!(id)
    v = Groups.get_volunteer!(vid)

    case {Groups.is_chair?(wg, v), Enum.count(wg.chairs)} do
      {false, _} ->
        msg = """
        You tried to delete a chair from this working group, but the volunteer you specified
        is not a chair of this working group.
        """

        conn
        |> put_flash(:error, msg)
        |> redirect(to: Routes.admin_working_group_path(conn, :show, wg.id))

      {true, 1} ->
        msg = """
        A working group must have at least one chair. Assign a co-chair and try again.
        """

        conn
        |> put_flash(:error, msg)
        |> redirect(to: Routes.admin_working_group_path(conn, :show, wg.id))

      {true, _} ->
        wgc = Groups.get_wg_chair!(id, vid)
        {:ok, _} = Groups.delete_wg_chair(wg, wgc, audit: audit(conn))

        conn
        |> put_flash(:info, "Volunteer successfully removed as chair.")
        |> redirect(to: Routes.admin_working_group_path(conn, :show, wgc.working_group_id))
    end
  end

  def delete_volunteer(conn, %{"id" => id, "volunteer_id" => vid}) do
    wg = Groups.get_working_group!(id)
    v = Groups.get_volunteer!(vid)

    case Groups.is_chair?(wg, v) do
      true ->
        msg = """
        You tried to delete a chair from this working group, but you must remove the volunteer as a 
        chair first.
        """

        conn
        |> put_flash(:error, msg)
        |> redirect(to: Routes.admin_working_group_path(conn, :show, wg.id))

      false ->
        wgv = Groups.get_wg_volunteer!(id, vid)
        {:ok, _} = Groups.delete_wg_volunteer(wg, wgv, audit: audit(conn))

        conn
        |> put_flash(:info, "Volunteer successfully removed.")
        |> redirect(to: Routes.admin_working_group_path(conn, :show, wgv.working_group_id))
    end
  end

  defp redirect_path(conn, %WorkingGroup{active: false}) do
    Routes.admin_working_group_path(conn, :index)
  end

  defp redirect_path(conn, working_group) do
    Routes.admin_working_group_path(conn, :show, working_group)
  end
end
