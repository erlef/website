defmodule ErlefWeb.EventSubmissionControllerTest do
  use ErlefWeb.ConnCase

  test "GET /event_submissions", %{conn: conn} do
    conn = get(conn, Routes.event_submission_path(conn, :index))

    assert html_response(conn, 200) =~ "Event Title"
  end

  #   test "GET /events/:id", %{conn: conn} do
  #     conn = get(conn, Routes.event_path(conn, :show, "code-elixir-ldn-2019"))
  #     assert html_response(conn, 200) =~ "Code Elixir LDN"
  #   end
  #
  #
  defp setup_session(conn) do
    Erlef.Session.login(:dev)
  end
end
