defmodule ErlefWeb.PageControllerTest do
  use ErlefWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "The Erlang Software Foundation’s goal is to grow"
  end
end
