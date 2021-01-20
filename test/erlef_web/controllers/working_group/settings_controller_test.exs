defmodule ErlefWeb.WorkingGroup.SettingsControllerTest do
  use ErlefWeb.ConnCase

  setup do
    # Get existing wg_chair member from wildapricot fake server
    {:ok, chair} = Erlef.Accounts.get_member("wg_chair")
    volunteer = insert(:volunteer, member_id: chair.id)
    wg = insert(:working_group)
    insert(:working_group_volunteer, volunteer: volunteer, working_group: wg)
    insert(:working_group_chair, volunteer: volunteer, working_group: wg)
    [working_group: wg]
  end

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
end
