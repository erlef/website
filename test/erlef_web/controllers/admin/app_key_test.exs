defmodule ErlefWeb.Admin.AppKeyTest do
  use ErlefWeb.ConnCase

  alias Erlef.Integrations

  @create_attrs %{
    name: "Key name",
    type: :webhook
  }

  @invalid_attrs %{name: nil, type: :foo}

  @audit_opts [audit: %{member_id: Ecto.UUID.generate()}]

  def fixture(:app) do
    {:ok, app} = Integrations.create_app(%{name: "Some app"}, @audit_opts)
    app
  end

  def fixture(:app_key, app) do
    {:ok, app_key} = Integrations.create_app_key(app, @create_attrs, @audit_opts)
    app_key
  end

  describe "create app key" do
    setup [:admin_session, :create_app_key]

    test "redirects to show when data is valid", %{conn: conn, app: app} do
      conn =
        post(conn, Routes.admin_app_key_path(conn, :create, app.slug), app_key: @create_attrs)

      assert redirected_to(conn) == Routes.admin_app_key_path(conn, :index, app.slug)
    end

    test "renders errors when data is invalid", %{conn: conn, app: app} do
      conn =
        post(conn, Routes.admin_app_key_path(conn, :create, app.slug), app_key: @invalid_attrs)

      assert redirected_to(conn) == Routes.admin_app_key_path(conn, :index, app.slug)
    end
  end

  describe "revoke app key" do
    setup [:admin_session, :create_app_key]

    test "redirects to show when data is valid", %{conn: conn, app: app, app_key: app_key} do
      conn = delete(conn, Routes.admin_app_key_path(conn, :delete, app.slug, app_key.id))

      assert redirected_to(conn) == Routes.admin_app_key_path(conn, :index, app.slug)
    end

    # This will raise currently
    # test "renders errors when data is invalid", %{conn: conn, app: app} do
    #   conn = delete(conn, Routes.admin_app_key_path(conn, :delete, app, Ecto.UUID.generate()))
    #   assert redirected_to(conn) == Routes.admin_app_path(conn, :show, app)
    # end
  end

  defp create_app_key(_) do
    app = fixture(:app)
    app_key = fixture(:app_key, app)
    %{app: app, app_key: app_key}
  end
end
