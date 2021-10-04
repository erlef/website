defmodule ErlefWeb.BlogControllerTest do
  use ErlefWeb.ConnCase

  alias Erlef.Blog

  @create_attrs %{
    title: "some title",
    excerpt: "some excerpt",
    body: "some body",
    authors: "some author, some other author",
    category: "eef",
    tags: "[{\"value\":\"some tag\"}, {\"value\":\"some other tag\"}]"
  }
  @update_attrs %{
    title: "some updated title",
    excerpt: "some updated excerpt",
    body: "some updated body",
    authors: "some updated author, some other updated author",
    category: "newsletter",
    tags: "[{\"value\":\"some updated tag\"}, {\"value\":\"some other updated tag\"}]"
  }
  @invalid_attrs %{
    title: nil,
    excerpt: nil,
    body: nil,
    authors: "",
    category: "eef",
    tags: nil,
    status: "42"
  }

  setup do
    wg =
      build(:working_group, %{
        name: "Fellowship",
        slug: "fellowship",
        description: "members for a fellowship role"
      })

    member = insert!(:member)
    volunteer = build(:volunteer, member_id: member.id)

    wgv = insert!(:working_group_volunteer, working_group: wg, volunteer: volunteer)
    insert!(:working_group_chair, volunteer: wgv.volunteer, working_group: wgv.working_group)

    {:ok, post} =
      Blog.create_post(%{
        title: "Honoring our fellows",
        body: "The First Fellows",
        authors: ["Author"],
        category: "fellowship",
        tags: ["eef"],
        status: "published",
        owner_id: member.id
      })

    [working_group: wgv.working_group, volunteer: wgv.volunteer, post: post]
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
    assert html_response(conn, 404) =~ "Oops! Page not found"
  end

  test "GET /blog/tags/eef", %{conn: conn} do
    conn = get(conn, Routes.blog_path(conn, :tags, "eef"))
    assert html_response(conn, 200) =~ "Posts with tag eef found"
  end

  describe "create post" do
    setup :admin_session

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.blog_path(conn, :create), post: @create_attrs)

      assert %{topic: topic, id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.blog_path(conn, :show, topic, id)

      conn = get(conn, Routes.blog_path(conn, :show, topic, id))
      assert html_response(conn, 200) =~ @create_attrs.title
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.blog_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Creating Post"
    end
  end

  describe "edit post" do
    setup :admin_session

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      conn = get(conn, Routes.blog_path(conn, :edit, post.slug))
      assert html_response(conn, 200) =~ "Editing Post"
    end
  end

  describe "update post" do
    setup :admin_session

    test "redirects when data is valid", %{conn: conn, post: post} do
      conn = put(conn, Routes.blog_path(conn, :update, post.slug), post: @update_attrs)

      assert redirected_to(conn) ==
               Routes.blog_path(conn, :show, "newsletter", "some-updated-title")

      conn = get(conn, Routes.blog_path(conn, :show, "newsletter", "some-updated-title"))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put(conn, Routes.blog_path(conn, :update, post.slug), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Editing Post"
    end
  end
end
