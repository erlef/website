defmodule ErlefWeb.PlugsTest do
  use ErlefWeb.ConnCase

  alias Erlef.Session
  alias ErlefWeb.Plug.Authz
  alias ErlefWeb.Plug.Authz.{Admin, Chair}
  # alias ErlefWeb.Plug.CurrentWorkingGroup
  alias Erlef.Accounts.Member

  test "get admin resource when not an admin", %{conn: conn} do
    conn = get(conn, Routes.admin_dashboard_path(conn, :index))
    assert redirected_to(conn) == Routes.page_path(conn, :index)
    conn = get(conn, Routes.admin_app_path(conn, :index))
    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end

  describe "Authz" do
    test "init/1" do
      assert Authz.init([]) == []
    end

    test "when conn has a member_session", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{member_session: session()})
        |> fetch_flash()
        |> fetch_session()

      conn = Authz.call(conn, [])
      assert conn.state == :sent
    end

    test "when conn does not have a member_session", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{})
        |> fetch_flash()
        |> fetch_session()

      conn = Authz.call(conn, [])
      assert redirected_to(conn) == Routes.page_path(conn, :index)

      assert get_session(conn, :return_to) == "/"

      assert get_flash(conn, :notice) =~
               "The resource you requested requires that you are logged in"
    end
  end

  describe "Authz.Admin" do
    test "init/1" do
      assert Admin.init([]) == []
    end

    test "when is admin", %{conn: conn} do
      conn = assign(conn, :current_user, %Member{is_app_admin: true})
      conn = Admin.call(conn, [])
      assert conn.state == :unset
    end

    test "when is not admin", %{conn: conn} do
      conn = assign(conn, :current_user, %Member{is_app_admin: false})
      conn = Admin.call(conn, [])
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "Authz.Chair" do
    test "init/1" do
      assert Chair.init([]) == []
    end

    test "when is_chair is set", %{conn: conn} do
      conn = assign(conn, :is_chair, true)
      conn = Chair.call(conn, [])
      assert conn.state == :unset
    end

    test "when is_chair is not set or false", %{conn: conn} do
      conn = Chair.call(conn, [])
      assert redirected_to(conn) == Routes.page_path(conn, :index)

      conn =
        conn
        |> recycle()
        |> assign(:is_chair, false)

      conn = Chair.call(conn, [])
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  defp session() do
    %Session{
      account_id: 123,
      member_id: Ecto.UUID.generate(),
      access_token: "token",
      refresh_token: "rt_token",
      username: "me",
      expires_at: 600,
      erlef_app_id: Ecto.UUID.generate()
    }
  end
end
