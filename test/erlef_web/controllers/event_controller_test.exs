defmodule ErlefWeb.EventControllerTest do
  use ErlefWeb.ConnCase

  test "GET /events", %{conn: conn} do
    conn = get(conn, Routes.event_path(conn, :index))

    assert html_response(conn, 200) =~
             "The EEF participates in many events related to the BEAM Community."
  end

  test "GET /events/:id", %{conn: conn} do
    conn = get(conn, Routes.event_path(conn, :show, "code-elixir-ldn-2019"))
    assert html_response(conn, 200) =~ "Code Elixir LDN"
  end
end
