defmodule ErlefWeb.NewsTipControllerTest do
  use ErlefWeb.ConnCase

  @create_attrs %{
    type: :announcement,
    status: :created,
    who: "some who",
    what: "some what",
    at_where: "some where",
    at_when: "some at_when",
    why: "some why",
    how: "some how",
    supporting_documents: [
      %Plug.Upload{path: "test/fixtures/eef.png", content_type: "image/png", filename: "eef.png"}
    ],
    additional_info: "some additional_info"
  }

  @invalid_attrs %{
    additional_info: nil,
    flags: nil,
    how: nil,
    links: nil,
    operator_notes: nil,
    priority: nil,
    status: nil,
    suggested_mediums: nil,
    supporting_documents: nil,
    type: nil,
    what: nil,
    at_when: nil,
    at_where: nil,
    who: nil,
    why: nil
  }

  describe "index" do
    setup :basic_session

    test "lists all news tips created by the current user", %{
      conn: conn
    } do
      conn = get(conn, Routes.news_tip_path(conn, :index))
      assert html_response(conn, 200) =~ "My news tips"
    end
  end

  describe "new news tip" do
    setup :basic_session

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.news_tip_path(conn, :new))
      assert html_response(conn, 200) =~ "Submit a news tip"
    end
  end

  describe "create news_tip" do
    setup :basic_session

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.news_tip_path(conn, :create), news_tip: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.news_tip_path(conn, :show, id)

      conn = get(conn, Routes.news_tip_path(conn, :show, id))
      assert html_response(conn, 200) =~ "News tip"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.news_tip_path(conn, :create), news_tip: @invalid_attrs)

      assert html_response(conn, 200) =~ "Submit a news tip"
    end
  end
end
