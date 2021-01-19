defmodule ErlefWeb.WorkingGroupControllerTest do
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

  test "GET /wg", %{conn: conn} do
    conn = get(conn, Routes.working_group_path(conn, :index))
    assert html_response(conn, 200) =~ "the EEF sponsors Working"
  end

  test "GET /wg/:id", %{conn: conn, working_group: wg} do
    conn = get(conn, Routes.working_group_path(conn, :show, wg.slug))
    name = wg.name
    assert html_response(conn, 200) =~ name
  end

  describe "edit working_group" do
    setup :chair_session

    test "renders form for editing for chosen working_group", %{conn: conn, working_group: wg} do
      conn = get(conn, Routes.working_group_path(conn, :edit, wg.slug))
      assert html_response(conn, 200) =~ wg.name
    end
  end

  describe "update working_group" do
    setup :chair_session

    test "redirects when data is valid", %{conn: conn, working_group: wg} do
      conn =
        put(conn, Routes.working_group_path(conn, :update, wg.slug),
          working_group: %{charter: "# charter", description: "description"}
        )

      assert redirected_to(conn) == Routes.working_group_path(conn, :show, wg.slug)
    end

    test "renders errors when data is invalid", %{conn: conn, working_group: wg} do
      conn =
        put(conn, Routes.working_group_path(conn, :update, wg.slug),
          working_group: %{charter: nil, description: 12345}
        )

      assert html_response(conn, 200) =~ wg.name
    end
  end
end
