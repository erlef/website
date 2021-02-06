defmodule ErlefWeb.Admin.WorkingGroupControllerTest do
  use ErlefWeb.ConnCase

  alias Erlef.Repo
  alias Erlef.Groups
  alias Erlef.Groups.{WorkingGroupChair, WorkingGroupVolunteer}

  @update_attrs %{
    description: "To do things",
    formed: "2019-04-30",
    charter: "Foo",
    charter_html: "<p>Foo</p>",
    meta: %{
      email: "local-282@erlef.org",
      gcal_url: nil,
      github: nil
    },
    name: "Local 242",
    slug: "local-242",
    updated_by: Ecto.UUID.generate()
  }

  @invalid_attrs %{
    description: nil,
    formed: "2019-04-30",
    charter: nil,
    charter_html: Date.utc_today(),
    meta: %{
      email: nil,
      gcal_url: nil,
      github: nil
    },
    name: 123,
    slug: nil
  }

  setup do
    v = insert!(:volunteer)
    chair = insert!(:volunteer)
    wg = insert!(:working_group)
    {:ok, admin} = Erlef.Accounts.get_member("admin")

    audit_opts = [audit: %{member_id: admin.id}]

    {:ok, %WorkingGroupChair{}} = Groups.create_wg_chair(wg, chair, audit_opts)

    {:ok, %WorkingGroupVolunteer{}} = Groups.create_wg_volunteer(wg, v, audit_opts)

    {:ok, wg} = Erlef.Groups.get_working_group_by_slug(wg.slug)

    [
      admin: admin,
      chair: Repo.preload(chair, :working_groups),
      volunteer: Repo.preload(v, :working_groups),
      working_group: Repo.preload(wg, :volunteers)
    ]
  end

  describe "index" do
    setup :admin_session

    test "lists all working_groups", %{conn: conn} do
      conn = get(conn, Routes.admin_working_group_path(conn, :index))
      assert html_response(conn, 200) =~ "Working Groups"
    end
  end

  describe "edit working_group" do
    setup :admin_session

    test "renders form for editing chosen working_group", %{
      conn: conn,
      working_group: working_group
    } do
      conn = get(conn, Routes.admin_working_group_path(conn, :edit, working_group))
      assert html_response(conn, 200) =~ working_group.name
    end
  end

  describe "update working_group" do
    setup :admin_session

    test "redirects when data is valid", %{conn: conn, working_group: working_group, admin: admin} do
      conn =
        put(conn, Routes.admin_working_group_path(conn, :update, working_group),
          working_group: @update_attrs
        )

      assert redirected_to(conn) == Routes.admin_working_group_path(conn, :show, working_group)

      conn = get(conn, Routes.admin_working_group_path(conn, :show, working_group))
      assert html_response(conn, 200) =~ "local-282@erlef.org"
      assert html_response(conn, 200) =~ "Updated by:</b> #{admin.id}"
    end

    test "renders errors when data is invalid", %{conn: conn, working_group: working_group} do
      conn =
        put(conn, Routes.admin_working_group_path(conn, :update, working_group),
          working_group: @invalid_attrs
        )

      assert html_response(conn, 200) =~ working_group.name
    end
  end

  describe "assign volunteer as chair" do
    setup :admin_session

    test "creates chair when data is valid", %{
      conn: conn,
      working_group: working_group,
      volunteer: vol
    } do
      conn = put(conn, Routes.admin_working_group_path(conn, :create_chair, working_group, vol))
      assert redirected_to(conn) == Routes.admin_working_group_path(conn, :show, working_group)
      assert %{"info" => "Successfully assigned volunteer as chair."} = get_flash(conn)
    end
  end

  describe "remove volunteer as chair" do
    setup :admin_session

    test "removes volunteer when more than one chair exists", %{
      conn: conn,
      working_group: working_group,
      volunteer: vol
    } do
      conn = put(conn, Routes.admin_working_group_path(conn, :create_chair, working_group, vol))
      assert redirected_to(conn) == Routes.admin_working_group_path(conn, :show, working_group)
      assert %{"info" => "Successfully assigned volunteer as chair."} = get_flash(conn)

      conn =
        delete(conn, Routes.admin_working_group_path(conn, :delete_chair, working_group, vol))

      assert redirected_to(conn) == Routes.admin_working_group_path(conn, :show, working_group)
      assert %{"info" => "Volunteer successfully removed as chair."} = get_flash(conn)
    end

    test "does not remove volunteer when only one chair exists", %{
      conn: conn,
      working_group: working_group,
      chair: chair
    } do
      conn =
        delete(conn, Routes.admin_working_group_path(conn, :delete_chair, working_group, chair))

      assert redirected_to(conn) == Routes.admin_working_group_path(conn, :show, working_group)
      assert %{"error" => _} = get_flash(conn)
    end
  end

  describe "remove volunteer" do
    setup :admin_session

    test "removes volunteer when volunteer is not a chair", %{
      conn: conn,
      working_group: working_group,
      volunteer: vol
    } do
      conn =
        delete(conn, Routes.admin_working_group_path(conn, :delete_volunteer, working_group, vol))

      assert redirected_to(conn) == Routes.admin_working_group_path(conn, :show, working_group)
      assert %{"info" => "Volunteer successfully removed."} = get_flash(conn)
    end

    test "does not remove volunteer when volunteer is still a chair", %{
      conn: conn,
      working_group: working_group,
      volunteer: vol
    } do
      conn = put(conn, Routes.admin_working_group_path(conn, :create_chair, working_group, vol))
      assert redirected_to(conn) == Routes.admin_working_group_path(conn, :show, working_group)
      assert %{"info" => "Successfully assigned volunteer as chair."} = get_flash(conn)

      conn =
        delete(conn, Routes.admin_working_group_path(conn, :delete_volunteer, working_group, vol))

      assert redirected_to(conn) == Routes.admin_working_group_path(conn, :show, working_group)
      assert %{"error" => _} = get_flash(conn)
    end

    test "does not remove volunteer when volunteer is the only chair", %{
      conn: conn,
      working_group: working_group,
      chair: chair
    } do
      conn =
        delete(
          conn,
          Routes.admin_working_group_path(conn, :delete_volunteer, working_group, chair)
        )

      assert redirected_to(conn) == Routes.admin_working_group_path(conn, :show, working_group)
      assert %{"error" => _} = get_flash(conn)
    end
  end
end
