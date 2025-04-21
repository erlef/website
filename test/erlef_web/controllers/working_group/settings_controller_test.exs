defmodule ErlefWeb.WorkingGroup.SettingsControllerTest do
  use ErlefWeb.ConnCase

  alias Erlef.Groups
  alias Erlef.Groups.{WorkingGroupChair, WorkingGroupVolunteer}
  alias Erlef.Repo

  setup do
    v = insert!(:volunteer)
    member = insert_member!("wg_chair")
    admin = insert_member!("admin")
    chair = insert!(:volunteer, member_id: member.id)
    wg = insert!(:working_group)
    audit_opts = [audit: %{member_id: admin.id}]

    {:ok, %WorkingGroupChair{}} = Groups.create_wg_chair(wg, chair, audit_opts)

    {:ok, %WorkingGroupVolunteer{}} = Groups.create_wg_volunteer(wg, v, audit_opts)

    {:ok, wg} = Erlef.Groups.get_working_group_by_slug(wg.slug)

    [
      chair: Repo.preload(chair, :working_groups),
      volunteer: Repo.preload(v, :working_groups),
      working_group: Repo.preload(wg, :volunteers)
    ]
  end

  #   setup do
  #     # Get existing wg_chair member from wildapricot fake server
  #     {:ok, chair} = Erlef.Accounts.get_member("wg_chair")
  #     volunteer = insert!(:volunteer, member_id: chair.id)
  #     wg = insert!(:working_group)
  #     insert!(:working_group_volunteer, volunteer: volunteer, working_group: wg)
  #     insert!(:working_group_chair, volunteer: volunteer, working_group: wg)
  #     [chair: chair, volunteer: volunteer, working_group: wg]
  #   end

  describe "edit working_group" do
    setup :chair_session

    test "renders form for editing for chosen working_group", %{conn: conn, working_group: wg} do
      conn = get(conn, Routes.working_group_settings_path(conn, :edit, wg.slug))
      assert html_response(conn, 200) =~ wg.name
    end
  end

  describe "update working_group" do
    setup :chair_session

    test "redirects when data is valid", %{conn: conn, working_group: wg} do
      conn =
        put(conn, Routes.working_group_settings_path(conn, :update, wg.slug),
          working_group: %{charter: "# charter", description: "description"}
        )

      assert redirected_to(conn) == Routes.working_group_settings_path(conn, :edit, wg.slug)
    end

    test "renders errors when data is invalid", %{conn: conn, working_group: wg} do
      conn =
        put(conn, Routes.working_group_settings_path(conn, :update, wg.slug),
          working_group: %{charter: nil, description: 12_345}
        )

      assert html_response(conn, 200) =~ wg.name
    end
  end

  describe "assign volunteer as chair" do
    setup :chair_session

    test "creates chair when data is valid", %{
      conn: conn,
      working_group: wg,
      volunteer: vol
    } do
      conn = put(conn, Routes.working_group_settings_path(conn, :create_chair, wg.slug, vol))

      assert redirected_to(conn) == Routes.working_group_settings_path(conn, :edit, wg.slug)
      assert %{"info" => "Successfully assigned volunteer as chair."} = conn.assigns.flash
    end
  end

  describe "remove volunteer as chair" do
    setup :chair_session

    test "removes volunteer when more than one chair exists", %{
      conn: conn,
      working_group: wg,
      volunteer: vol
    } do
      conn = put(conn, Routes.working_group_settings_path(conn, :create_chair, wg.slug, vol))
      assert redirected_to(conn) == Routes.working_group_settings_path(conn, :edit, wg.slug)
      assert %{"info" => "Successfully assigned volunteer as chair."} = conn.assigns.flash

      conn = delete(conn, Routes.working_group_settings_path(conn, :delete_chair, wg.slug, vol))

      assert redirected_to(conn) == Routes.working_group_settings_path(conn, :edit, wg.slug)
      assert %{"info" => "Volunteer successfully removed as chair."} = conn.assigns.flash
    end

    test "does not remove volunteer when only one chair exists", %{
      conn: conn,
      working_group: wg,
      chair: chair
    } do
      conn = delete(conn, Routes.working_group_settings_path(conn, :delete_chair, wg.slug, chair))

      assert redirected_to(conn) == Routes.working_group_settings_path(conn, :edit, wg.slug)
      assert %{"error" => _} = conn.assigns.flash
    end
  end

  describe "remove volunteer" do
    setup :chair_session

    test "removes volunteer when volunteer is not a chair", %{
      conn: conn,
      working_group: wg,
      volunteer: vol
    } do
      conn =
        delete(conn, Routes.working_group_settings_path(conn, :delete_volunteer, wg.slug, vol))

      assert redirected_to(conn) == Routes.working_group_settings_path(conn, :edit, wg.slug)
      assert %{"info" => "Volunteer successfully removed."} = conn.assigns.flash
    end

    test "does not remove volunteer when volunteer is still a chair", %{
      conn: conn,
      working_group: wg,
      volunteer: vol
    } do
      conn = put(conn, Routes.working_group_settings_path(conn, :create_chair, wg.slug, vol))
      assert redirected_to(conn) == Routes.working_group_settings_path(conn, :edit, wg.slug)
      assert %{"info" => "Successfully assigned volunteer as chair."} = conn.assigns.flash

      conn =
        delete(conn, Routes.working_group_settings_path(conn, :delete_volunteer, wg.slug, vol))

      assert redirected_to(conn) == Routes.working_group_settings_path(conn, :edit, wg.slug)
      assert %{"error" => _} = conn.assigns.flash
    end

    test "does not remove volunteer when volunteer is the only chair", %{
      conn: conn,
      working_group: wg,
      chair: chair
    } do
      conn =
        delete(
          conn,
          Routes.working_group_settings_path(conn, :delete_volunteer, wg.slug, chair.id)
        )

      assert redirected_to(conn) == Routes.working_group_settings_path(conn, :edit, wg.slug)
      assert %{"error" => _} = conn.assigns.flash
    end
  end
end
