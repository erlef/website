defmodule ErlefWeb.GrantControllerTest do
  use ErlefWeb.ConnCase

  test "GET /grants", %{conn: conn} do
    conn = get(conn, Routes.grant_path(conn, :index))
    assert html_response(conn, 200) =~ "Grant request process"
  end
end
