defmodule ErlefWeb.WorkingGroupControllerTest do
  use ErlefWeb.ConnCase

  test "GET /wg", %{conn: conn} do
    conn = get(conn, Routes.working_group_path(conn, :index))
    assert html_response(conn, 200) =~ "the EEF sponsors Working"
  end

  test "GET /wg/:id", %{conn: conn} do
    conn = get(conn, Routes.working_group_path(conn, :show, "marketing"))
    assert html_response(conn, 200) =~ "Marketing Working Group"
  end
end
