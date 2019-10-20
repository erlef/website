defmodule ErlefWeb.EventControllerTest do
  use ErlefWeb.ConnCase

  test "GET /events", %{conn: conn} do
    conn = get(conn, Routes.event_path(conn, :index))
    assert html_response(conn, 200) =~ "id=\"calendar\""
  end
end
