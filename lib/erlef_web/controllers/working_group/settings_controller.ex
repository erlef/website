defmodule ErlefWeb.WorkingGroup.SettingsController do
  use ErlefWeb, :controller

  alias Erlef.Groups

  action_fallback ErlefWeb.FallbackController

  def edit(conn, %{"slug" => _slug}) do
    wg = conn.assigns.current_working_group

    render(conn, "edit.html",
      wg: wg,
      changeset: Groups.change_working_group(wg)
    )
  end

  def update(conn, %{"slug" => _slug, "working_group" => params}) do
    wg = conn.assigns.current_working_group

    case Groups.update_working_group(wg, params, audit: audit(conn)) do
      {:ok, _wg} ->
        conn
        |> put_flash(:info, "Working group updated successfully.")
        |> redirect(to: Routes.working_group_settings_path(conn, :edit, wg.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          wg: wg,
          changeset: changeset
        )
    end
  end

  def create_chair(conn, %{"slug" => slug, "volunteer_id" => vid}) do
    {:ok, wg} = Groups.get_working_group_by_slug(slug)
    v = Groups.get_volunteer!(vid)

    case Groups.create_wg_chair(wg, v, audit: audit(conn)) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Successfully assigned volunteer as chair.")
        |> redirect(to: Routes.working_group_settings_path(conn, :edit, wg.slug))

      _err ->
        conn
        |> put_flash(:error, "Error assigning volunteer as chair.")
        |> redirect(to: Routes.working_group_settings_path(conn, :edit, wg.slug))
    end
  end

  def delete_chair(conn, %{"slug" => slug, "volunteer_id" => vid}) do
    {:ok, wg} = Groups.get_working_group_by_slug(slug)
    v = Groups.get_volunteer!(vid)

    case {Groups.is_chair?(wg, v), Enum.count(wg.chairs)} do
      {false, _} ->
        msg = """
        You tried to delete a chair from this working group, but the volunteer you specified
        is not a chair of this working group.
        """

        conn
        |> put_flash(:error, msg)
        |> redirect(to: Routes.working_group_settings_path(conn, :edit, wg.slug))

      {true, 1} ->
        msg = """
        A working group must have at least one chair. Assign a co-chair and try again.
        """

        conn
        |> put_flash(:error, msg)
        |> redirect(to: Routes.working_group_settings_path(conn, :edit, wg.slug))

      {true, _} ->
        wgc = Groups.get_wg_chair!(wg.id, vid)
        {:ok, _} = Groups.delete_wg_chair(wg, wgc, audit: audit(conn))

        conn
        |> put_flash(:info, "Volunteer successfully removed as chair.")
        |> redirect(to: Routes.working_group_settings_path(conn, :edit, wg.slug))
    end
  end

  def delete_volunteer(conn, %{"slug" => slug, "volunteer_id" => vid}) do
    {:ok, wg} = Groups.get_working_group_by_slug(slug)
    v = Groups.get_volunteer!(vid)

    case Groups.is_chair?(wg, v) do
      true ->
        msg = """
        You tried to delete a chair from this working group, but you must remove the volunteer as a 
        chair first.
        """

        conn
        |> put_flash(:error, msg)
        |> redirect(to: Routes.working_group_settings_path(conn, :edit, wg.slug))

      false ->
        wgv = Groups.get_wg_volunteer!(wg.id, vid)
        {:ok, _} = Groups.delete_wg_volunteer(wg, wgv, audit: audit(conn))

        conn
        |> put_flash(:info, "Volunteer successfully removed.")
        |> redirect(to: Routes.working_group_settings_path(conn, :edit, wg.slug))
    end
  end
end
