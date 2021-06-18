defmodule ErlefWeb.PageControllerTest do
  use ErlefWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :index))

    assert html_response(conn, 200) =~
             "The Erlang Ecosystem Foundation is a 501(c)(3) not-for-profit organization"
  end

  test "GET /bylaws", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :bylaws))
    assert html_response(conn, 200) =~ "Bylaws of the"
  end

  test "GET /sponsors", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :sponsors))
    assert html_response(conn, 200) =~ "Become a sponsor!"
  end

  test "GET /board_members", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :board_members))
    assert html_response(conn, 200) =~ "EEF Board Members"
  end

  test "GET /faq", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :faq))
    assert html_response(conn, 200) =~ "Why should I join the foundation?"
  end

  test "GET /wg-proposal-template", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :wg_proposal_template))
    assert html_response(conn, 200) =~ "name of the newly formed group"
  end

  test "GET /contact", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :contact))
    assert html_response(conn, 200) =~ "Contact"
  end

  test "GET /community", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :community))
    assert html_response(conn, 200) =~ "Help us grow our community"
  end

  test "GET /fellows", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :fellows))
    assert html_response(conn, 200) =~ "What is a fellow?"
  end
end
