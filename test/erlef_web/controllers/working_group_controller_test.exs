defmodule ErlefWeb.WorkingGroupControllerTest do
  use ErlefWeb.ConnCase

  setup do
    wgv = insert(:working_group_volunteer)
    insert(:working_group_chair, volunteer: wgv.volunteer, working_group: wgv.working_group)
    [working_group: wgv.working_group]
  end

  test "GET /wg", %{conn: conn} do
    conn = get(conn, Routes.working_group_path(conn, :index))
    assert html_response(conn, 200) =~ "the EEF sponsors Working"
  end

  test "GET /wg/:id", %{conn: conn, working_group: wg} do
    conn = get(conn, Routes.working_group_path(conn, :show, wg.slug))
    name = wg.name
    assert html_response(conn, 200) =~ name
  end
end
