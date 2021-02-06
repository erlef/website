defmodule ErlefWeb.WorkingGroupControllerTest do
  use ErlefWeb.ConnCase

  setup do
    # Get existing wg_chair member from wildapricot fake server
    {:ok, chair} = Erlef.Accounts.get_member("wg_chair")
    volunteer = insert!(:volunteer, member_id: chair.id)
    wg = insert!(:working_group)
    insert!(:working_group_volunteer, volunteer: volunteer, working_group: wg)
    insert!(:working_group_chair, volunteer: volunteer, working_group: wg)
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
end
