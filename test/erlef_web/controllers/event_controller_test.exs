defmodule ErlefWeb.EventControllerTest do
  use ErlefWeb.ConnCase

  test "GET /events", %{conn: conn} do
    conn = get(conn, Routes.event_path(conn, :index))

    assert html_response(conn, 200) =~
             "The EEF participates in many events related to the BEAM Community."
  end

  test "GET /event/:id", %{conn: conn} do
    e =
      insert(:event,
        type: :meetup,
        approved: true,
        approved_by: Ecto.UUID.generate(),
        slug: "eh"
      )

    conn = get(conn, Routes.event_path(conn, :show, e.id))

    assert html_response(conn, 200)
  end
end
