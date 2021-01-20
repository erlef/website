defmodule ErlefWeb.WorkingGroup.ReportControllerTest do
  use ErlefWeb.ConnCase

  alias Erlef.Groups

  @create_attrs %{content: "some content", is_private: true, meta: %{}, type: "quarterly"}
  @invalid_attrs %{content: nil, is_private: nil, meta: nil, type: nil}

  def fixture(:working_group_report) do
    {:ok, working_group_report} = Groups.create_wg_report(@create_attrs)
    working_group_report
  end

  setup do
    {:ok, member} = Erlef.Accounts.get_member("wg_chair")
    opts = [audit: %{member_id: member.id}]
    {:ok, v} = Erlef.Groups.create_volunteer(%{name: member.name, member_id: member.id}, opts)
    wgv = insert(:working_group_volunteer, volunteer: v)
    insert(:working_group_chair, volunteer: wgv.volunteer, working_group: wgv.working_group)
    [working_group: wgv.working_group]
  end

  describe "new working_group_report" do
    setup :chair_session

    test "renders form", %{conn: conn, working_group: wg} do
      conn = get(conn, Routes.working_group_report_path(conn, :new, wg.slug))
      assert html_response(conn, 200) =~ "New #{wg.name} Working Group Report"
    end
  end

  describe "create working_group_report" do
    setup :chair_session

    test "redirects to show when data is valid", %{conn: conn, working_group: wg} do
      upload = %Plug.Upload{path: "test/fixtures/markdown.md", filename: "markdown.md"}

      conn =
        post(conn, Routes.working_group_report_path(conn, :create, wg.slug),
          working_group_report: Map.put(@create_attrs, :file, upload)
        )

      assert %{slug: _slug} = redirected_params(conn)
      assert redirected_to(conn) == Routes.working_group_path(conn, :show, wg.slug)
    end

    test "renders errors when data is invalid", %{conn: conn, working_group: wg} do
      conn =
        post(conn, Routes.working_group_report_path(conn, :create, wg.slug),
          working_group_report: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "New #{wg.name} Working Group Report"
    end
  end
end
