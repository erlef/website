defmodule ErlefWeb.BlogControllerTest do
  use ErlefWeb.ConnCase

  @invalid_attrs %{
    title: nil,
    excerpt: nil,
    body: nil,
    authors: [],
    category: "eef",
    tags: nil,
    status: "42"
  }

  setup do
    chair = insert_member!("wg_chair")
    vol = insert!(:volunteer, member_id: chair.id)
    wg1 = insert!(:working_group)
    wg2 = insert!(:working_group)

    _wgv = insert!(:working_group_volunteer, working_group: wg1, volunteer: vol)
    _wgv = insert!(:working_group_volunteer, working_group: wg2, volunteer: vol)

    post = insert!(:post, category: wg1.slug, status: :published)

    [
      chair: chair,
      wg1: wg1,
      wg2: wg2,
      post: post
    ]
  end

  test "GET /news", %{conn: conn} do
    conn = get(conn, Routes.news_path(conn, :index))
    assert html_response(conn, 200) =~ "Find all the related news"
  end

  test "GET /news/:topic", %{conn: conn, post: post} do
    conn = get(conn, Routes.blog_path(conn, :index, post.category))
    assert html_response(conn, 200) =~ post.title

    # Deprecated, but kept in place for backwards compat
    conn = get(conn, Routes.news_path(conn, :index, post.category))
    assert html_response(conn, 200) =~ post.title
  end

  test "GET /news/:topic/:id", %{conn: conn, post: post} do
    conn = get(conn, Routes.blog_path(conn, :show, post.category, post.slug))
    assert html_response(conn, 200) =~ post.title

    # Deprecated, but kept in place for backwards compat
    conn = get(conn, Routes.news_path(conn, :show, post.category, post.slug))
    assert html_response(conn, 200) =~ post.title
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
    setup :chair_session

    test "redirects to show when data is valid", %{conn: conn, chair: chair, wg1: wg1} do
      post =
        build(:post, category: wg1.slug, owner: chair, status: :published)
        |> Map.from_struct()

      conn = post(conn, Routes.blog_path(conn, :create), post: post)

      assert %{topic: topic, id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.blog_path(conn, :show, topic, id)

      conn = get(conn, Routes.blog_path(conn, :show, topic, id))
      assert html_response(conn, 200) =~ post.title
    end

    test "renders errors when data is invalid", %{conn: conn, wg1: wg1} do
      conn =
        post(conn, Routes.blog_path(conn, :create), post: %{@invalid_attrs | category: wg1.slug})

      assert html_response(conn, 200) =~ "Creating Post"
    end
  end

  describe "edit post" do
    setup :chair_session

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      conn = get(conn, Routes.blog_path(conn, :edit, post.slug))
      assert html_response(conn, 200) =~ "Editing Post"
    end
  end

  describe "update post" do
    setup :chair_session

    test "redirects when data is valid", %{conn: conn, chair: chair, wg2: wg2, post: post} do
      updated_post =
        build(:post, category: wg2.slug, owner: chair, status: :published)
        |> Map.from_struct()

      conn = put(conn, Routes.blog_path(conn, :update, post.slug), post: updated_post)

      assert redirected_to(conn) ==
               Routes.blog_path(
                 conn,
                 :show,
                 updated_post.category,
                 Slug.slugify(updated_post.title)
               )

      conn =
        get(
          conn,
          Routes.blog_path(conn, :show, updated_post.category, Slug.slugify(updated_post.title))
        )

      assert html_response(conn, 200) =~ updated_post.title
    end

    test "renders errors when data is invalid", %{conn: conn, post: post, wg2: wg2} do
      conn =
        put(conn, Routes.blog_path(conn, :update, post.slug),
          post: %{@invalid_attrs | category: wg2.slug}
        )

      assert html_response(conn, 200) =~ "Editing Post"
    end
  end
end
