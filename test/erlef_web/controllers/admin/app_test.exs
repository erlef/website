defmodule ErlefWeb.Admin.AppTest do
  use ErlefWeb.ConnCase

  alias Erlef.Integrations

  @create_attrs %{
    name: "App name",
    slug: "app-name"
  }

  @update_attrs %{
    name: "some updated name",
    slug: "some-updated-name"
  }

  @invalid_attrs %{name: nil}

  @audit_opts [audit: %{member_id: Ecto.UUID.generate()}]

  def fixture(:app) do
    {:ok, app} = Integrations.create_app(@create_attrs, @audit_opts)
    app
  end

  describe "index" do
    setup [:admin_session, :create_app]

    test "lists all apps", %{conn: conn} do
      conn = get(conn, Routes.admin_app_path(conn, :index))
      assert html_response(conn, 200) =~ "New App"
    end
  end

  describe "edit app" do
    setup [:admin_session, :create_app]

    test "renders form for editing chosen app", %{
      conn: conn,
      app: app
    } do
      conn = get(conn, Routes.admin_app_path(conn, :edit, app.slug))
      assert html_response(conn, 200) =~ app.name
    end
  end

  describe "update app" do
    setup [:admin_session, :create_app]

    test "redirects when data is valid", %{conn: conn, app: app} do
      conn = put(conn, Routes.admin_app_path(conn, :update, app.slug), app: @update_attrs)

      assert redirected_to(conn) == Routes.admin_app_path(conn, :show, @update_attrs.slug)

      conn = get(conn, Routes.admin_app_path(conn, :show, @update_attrs.slug))
      assert html_response(conn, 200) =~ "App #{@update_attrs.name}"
    end

    test "renders errors when data is invalid", %{conn: conn, app: app} do
      conn = put(conn, Routes.admin_app_path(conn, :update, app.slug), app: @invalid_attrs)

      assert html_response(conn, 200) =~ "App #{app.name}"
    end
  end

  defp create_app(_) do
    app = fixture(:app)
    %{app: app}
  end
end
