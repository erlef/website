defmodule Erlef.BlogTest do
  use Erlef.DataCase

  alias Erlef.Blog

  describe "blog_posts" do
    alias Erlef.Blog.Post

    @valid_attrs %{
      title: "some title",
      excerpt: "some excerpt",
      body: "some body",
      authors: ["some author"],
      category: "eef",
      tags: ["some tag"],
      status: "archived"
    }
    @update_attrs %{
      title: "some updated title",
      excerpt: "some updated excerpt",
      body: "some updated body",
      authors: ["some updated author"],
      category: "newsletter",
      tags: ["some updated tag"]
    }
    @invalid_attrs %{
      title: nil,
      excerpt: nil,
      body: nil,
      authors: [],
      category: nil,
      tags: nil,
      status: "42",
      owner_id: nil
    }

    setup do
      admin = insert_member!("admin")
      member = insert_member!("basic_member")
      [admin: admin, member: member]
    end

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_post()

      post
    end

    test "list_blog_posts/0 returns all published blog_posts", %{admin: admin} do
      post = post_fixture(%{status: "published", owner_id: admin.id})
      assert Blog.list_blog_posts() == [post]
    end

    test "list_archived_blog_posts/1 returns all published blog_posts for an admin", %{
      admin: admin
    } do
      post = post_fixture(%{owner_id: admin.id})
      assert Blog.list_archived_blog_posts(admin) == {:ok, [post]}
    end

    test "list_archived_blog_posts/1 returns nothing for a basic member", %{
      admin: admin,
      member: member
    } do
      post_fixture(%{owner_id: admin.id})
      assert Blog.list_archived_blog_posts(member) == {:error, :not_allowed_to_post}
    end

    test "get_posts_by_tag/1 returns all published posts with the tag", %{admin: admin} do
      post = post_fixture(%{owner_id: admin.id, title: "1", status: "published", tags: ["T"]})
      post_fixture(%{owner_id: admin.id, title: "2", status: "archived", tags: ["T"]})
      assert Blog.get_posts_by_tag("T") == [post]
    end

    test "get_posts_by_category/1 returns all published posts in the category", %{admin: admin} do
      post = post_fixture(%{owner_id: admin.id, title: "1", status: "published", category: "C"})
      post_fixture(%{owner_id: admin.id, title: "2", status: "archived", category: "C"})
      assert Blog.get_posts_by_category("C") == [post]
    end

    test "get_post_by_slug!/1 returns the post with given slug", %{admin: admin} do
      post = post_fixture(%{owner_id: admin.id})
      assert Blog.get_post_by_slug!(post.slug) == post
    end

    test "get_post_by_slug/1 returns the post with given slug", %{admin: admin} do
      post = post_fixture(%{owner_id: admin.id})
      assert Blog.get_post_by_slug(post.slug) == {:ok, post}
      assert Blog.get_post_by_slug("not a slug") == {:error, :not_found}
    end

    test "latest_posts/0 return the latest 3 posts published", %{admin: admin} do
      assert Blog.latest_posts() == []
      post1 = post_fixture(%{owner_id: admin.id, title: "1", status: "published"})
      post2 = post_fixture(%{owner_id: admin.id, title: "2", status: "archived"})
      :timer.sleep(1000)
      post3 = post_fixture(%{owner_id: admin.id, title: "3", status: "published"})
      :timer.sleep(1000)
      post4 = post_fixture(%{owner_id: admin.id, title: "4", status: "published"})
      assert Blog.latest_posts() == [post4, post3, post1]
      :timer.sleep(1000)
      {:ok, post2} = Blog.update_post(post2, %{status: "published"})
      assert Blog.latest_posts() == [post2, post4, post3]
    end

    test "all_tags/0 returns all published posts tags", %{admin: admin} do
      post_fixture(%{owner_id: admin.id, title: "1", status: "published", tags: ["T1"]})
      post_fixture(%{owner_id: admin.id, title: "2", status: "archived", tags: ["T2, T3"]})
      post_fixture(%{owner_id: admin.id, title: "3", status: "published", tags: ["T3", "T4"]})
      assert Blog.all_tags() == ["T1", "T3", "T4"]
    end

    test "create_post/1 with valid data creates a post", %{admin: admin} do
      attrs = Map.put(@valid_attrs, :owner_id, admin.id)
      assert {:ok, %Post{} = post} = Blog.create_post(attrs)
      assert post.title == "some title"
      assert post.excerpt == "some excerpt"
      assert post.body == "some body"
      assert post.authors == ["some author"]
      assert post.category == "eef"
      assert post.tags == ["some tag"]
      assert post.status == :archived
      assert post.owner_id == admin.id
    end

    test "create_post/1 with invalid data returns error changeset", %{admin: admin} do
      attrs = Map.put(@valid_attrs, :owner_id, admin.id)
      {:ok, _post} = Blog.create_post(attrs)
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(attrs)
    end

    test "create_post/1 with repeated title returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post", %{admin: admin} do
      post = post_fixture(%{owner_id: admin.id})
      assert {:ok, %Post{} = post} = Blog.update_post(post, @update_attrs)
      assert post.title == "some updated title"
      assert post.excerpt == "some updated excerpt"
      assert post.body == "some updated body"
      assert post.authors == ["some updated author"]
      assert post.category == "newsletter"
      assert post.tags == ["some updated tag"]
    end

    test "update_post/2 with invalid data returns error changeset", %{admin: admin} do
      post = post_fixture(%{owner_id: admin.id})
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post_by_slug!(post.slug)
    end

    test "change_post/1 returns a post changeset", %{admin: admin} do
      post = post_fixture(%{owner_id: admin.id})
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end

    test "categories_allowed_to_post/1 returns nothing for a basic member", %{member: member} do
      categories = Blog.categories_allowed_to_post(member)
      assert categories == []
    end

    test "categories_allowed_to_post/1 returns everything for an admin", %{admin: admin} do
      categories = Blog.categories_allowed_to_post(admin)
      assert categories == ["eef", "newsletter"]
      wg = insert!(:working_group)
      categories = Blog.categories_allowed_to_post(admin)
      assert categories == ["eef", "newsletter", wg.slug]
    end

    test "categories_allowed_to_post/1 returns general categories for board member" do
      board_member = insert!(:member, %{membership_level: :board})
      categories = Blog.categories_allowed_to_post(board_member)
      assert categories == ["eef", "newsletter"]
      wg = insert!(:working_group)
      categories = Blog.categories_allowed_to_post(board_member)
      assert categories == ["eef", "newsletter"]
    end

    test "categories_allowed_to_post/1 returns working groups for volunteer", %{member: member} do
      wg1 = insert!(:working_group)
      wg2 = insert!(:working_group)
      volunteer = build(:volunteer, member_id: member.id)
      insert!(:working_group_volunteer, working_group: wg1, volunteer: volunteer)

      categories = Blog.categories_allowed_to_post(member)
      assert categories == [wg1.slug]
    end
  end
end
