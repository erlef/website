defmodule ErlefWeb.Admin.SponsorControllerTest do
  use ErlefWeb.ConnCase

  alias Erlef.Groups

  @create_attrs %{
    is_founding_sponsor: true,
    logo_url: "some logo_url",
    name: "some name",
    url: "some url",
    created_by: Ecto.UUID.generate()
  }
  @update_attrs %{
    is_founding_sponsor: false,
    logo_url: "some updated logo_url",
    name: "some updated name",
    url: "some updated url",
    updated_by: Ecto.UUID.generate()
  }
  @invalid_attrs %{is_founding_sponsor: nil, logo_url: nil, name: nil, url: nil}

  @audit_opts [audit: %{member_id: Ecto.UUID.generate()}]

  def fixture(:sponsor) do
    {:ok, sponsor} = Groups.create_sponsor(@create_attrs, @audit_opts)
    sponsor
  end

  describe "index" do
    setup :admin_session

    @tag :pending
    test "lists all sponsors", %{conn: conn} do
      conn = get(conn, Routes.admin_sponsor_path(conn, :index))
      assert html_response(conn, 200) =~ "Sponsors"
    end
  end

  describe "new sponsor" do
    setup :admin_session

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_sponsor_path(conn, :new))
      assert html_response(conn, 200) =~ "New Sponsor"
    end
  end

  describe "create sponsor" do
    setup :admin_session

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_sponsor_path(conn, :create), sponsor: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_sponsor_path(conn, :show, id)

      conn = get(conn, Routes.admin_sponsor_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Sponsor created successfully"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_sponsor_path(conn, :create), sponsor: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Sponsor"
    end
  end

  describe "edit sponsor" do
    setup [:admin_session, :create_sponsor]

    test "renders form for editing chosen sponsor", %{conn: conn, sponsor: sponsor} do
      conn = get(conn, Routes.admin_sponsor_path(conn, :edit, sponsor))
      assert html_response(conn, 200) =~ sponsor.name
    end
  end

  describe "update sponsor" do
    setup [:admin_session, :create_sponsor]

    test "redirects when data is valid", %{conn: conn, sponsor: sponsor} do
      conn = put(conn, Routes.admin_sponsor_path(conn, :update, sponsor), sponsor: @update_attrs)
      assert redirected_to(conn) == Routes.admin_sponsor_path(conn, :show, sponsor)

      conn = get(conn, Routes.admin_sponsor_path(conn, :show, sponsor))
      assert html_response(conn, 200) =~ "some updated logo_url"
    end

    test "renders errors when data is invalid", %{conn: conn, sponsor: sponsor} do
      conn = put(conn, Routes.admin_sponsor_path(conn, :update, sponsor), sponsor: @invalid_attrs)

      assert html_response(conn, 200) =~
               "Oops, something went wrong! Please check the errors below."
    end
  end

  defp create_sponsor(_) do
    sponsor = fixture(:sponsor)
    %{sponsor: sponsor}
  end
end
