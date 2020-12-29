defmodule ErlefWeb.BlogControllerTest do
  use ErlefWeb.ConnCase

  setup do
    wg =
      build(:working_group, %{
        name: "Fellowship",
        slug: "fellowship",
        description: "members for a fellowship role"
      })

    wgv = insert(:working_group_volunteer, working_group: wg)
    insert(:working_group_chair, volunteer: wgv.volunteer, working_group: wgv.working_group)
    [working_group: wgv.working_group]
  end

  test "GET /news", %{conn: conn} do
    conn = get(conn, Routes.news_path(conn, :index))
    assert html_response(conn, 200) =~ "Find all the related news"
  end

  test "GET /news/:topic", %{conn: conn} do
    conn = get(conn, Routes.blog_path(conn, :index, "fellowship"))
    assert html_response(conn, 200) =~ "members for a fellowship role"

    # Deprecated, but kept in place for backwards compat
    conn = get(conn, Routes.news_path(conn, :index, "fellowship"))
    assert html_response(conn, 200) =~ "members for a fellowship role"
  end

  test "GET /news/:topic/:id", %{conn: conn} do
    conn = get(conn, Routes.blog_path(conn, :show, "fellowship", "honoring-our-fellows"))
    assert html_response(conn, 200) =~ "The First Fellows"

    # Deprecated, but kept in place for backwards compat
    conn = get(conn, Routes.news_path(conn, :show, "fellowship", "honoring-our-fellows"))
    assert html_response(conn, 200) =~ "The First Fellows"
  end

  test "GET /news/:topic does not exist", %{conn: conn} do
    conn = get(conn, Routes.blog_path(conn, :index, "eh"))
    assert html_response(conn, 404) =~ "Not Found"
  end

  test "GET /blog/tags/eef", %{conn: conn} do
    conn = get(conn, Routes.blog_path(conn, :tags, "eef"))
    assert html_response(conn, 200) =~ "Posts with tag eef found"
  end
end
