defmodule ErlefWeb.EventControllerTest do
  use ErlefWeb.ConnCase

  test "GET /events", %{conn: conn} do
    conn = get(conn, Routes.event_path(conn, :index))

    assert html_response(conn, 200) =~
             "The EEF participates in many events related to the BEAM Community."
  end

  test "GET /event/:id", %{conn: conn} do
    member = insert_member!("basic_member")
    admin = insert_member!("admin")

    e =
      insert!(:event,
        type: :meetup,
        approved: true,
        submitted_by_id: member.id,
        approved_by_id: admin.id,
        slug: "eh"
      )

    conn = get(conn, Routes.event_path(conn, :show, e.id))

    assert html_response(conn, 200)
  end
end
