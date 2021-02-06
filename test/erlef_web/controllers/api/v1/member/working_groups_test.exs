defmodule ErlefWeb.API.V1.Member.WorkingGroupsControllerTest do
  use ErlefWeb.ConnCase

  alias Erlef.Repo
  alias Erlef.{Integrations, Groups}
  alias Erlef.Groups.{WorkingGroupVolunteer, WorkingGroupChair}

  setup %{conn: conn} do
    v = insert!(:volunteer)
    chair = insert!(:volunteer)
    wg1 = insert!(:working_group)
    wg2 = insert!(:working_group)

    audit_params = [audit: %{member_id: chair.id}]

    {:ok, app} = Integrations.create_app(%{name: "test", enabled: true}, audit_params)

    {:ok, app_key} =
      Integrations.create_app_key(app, %{type: :api_read_only, name: "test"}, audit_params)

    {:ok, %WorkingGroupChair{}} = Groups.create_wg_chair(wg1, chair, audit_params)

    {:ok, %WorkingGroupVolunteer{}} = Groups.create_wg_volunteer(wg1, chair, audit_params)

    {:ok, %WorkingGroupVolunteer{}} = Groups.create_wg_volunteer(wg1, v, audit_params)

    {:ok, %WorkingGroupChair{}} = Groups.create_wg_chair(wg2, chair, audit_params)

    {:ok, %WorkingGroupVolunteer{}} = Groups.create_wg_volunteer(wg2, chair, audit_params)

    {:ok, %WorkingGroupVolunteer{}} = Groups.create_wg_volunteer(wg2, v, audit_params)

    [
      chair: Repo.preload(chair, :working_groups),
      volunteer: Repo.preload(v, :working_groups),
      conn: setup_conn(conn, app_key.app_secret),
      app: app,
      app_key: app_key
    ]
  end

  # This test shoudl be moved else where, but works for now.
  describe "authorization" do
    test "returns 401 when not authorized", %{conn: conn} do
      conn =
        conn
        |> recycle()
        |> put_req_header("accept", "application/json")
        |> put_req_header("x-api-key", "eh?")
        |> get(Routes.api_v1_member_working_group_path(conn, :index, Ecto.UUID.generate()))

      assert json_response(conn, 401)
    end
  end

  describe "index" do
    test "lists all working groups a member belongs to", %{
      conn: conn,
      chair: chair,
      volunteer: vol,
      app_key: app_key
    } do
      conn = get(conn, Routes.api_v1_member_working_group_path(conn, :index, chair.member_id))
      assert [_group1, _group2] = groups = json_response(conn, 200)["data"]
      assert Enum.all?(groups, fn g -> g["is_chair"] end)

      conn =
        get(
          reset_conn(conn, app_key.app_secret),
          Routes.api_v1_member_working_group_path(conn, :index, vol.member_id)
        )

      assert [_group1, _group2] = groups = json_response(conn, 200)["data"]
      refute Enum.all?(groups, fn g -> g["is_chair"] end)
    end

    test "returns 404 when member does not exist", %{
      conn: conn
    } do
      conn =
        get(conn, Routes.api_v1_member_working_group_path(conn, :index, Ecto.UUID.generate()))

      assert json_response(conn, 404)["data"] == []
    end
  end

  defp setup_conn(conn, secret) do
    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("x-api-key", secret)
  end

  defp reset_conn(conn, secret) do
    conn
    |> recycle()
    |> setup_conn(secret)
  end
end
