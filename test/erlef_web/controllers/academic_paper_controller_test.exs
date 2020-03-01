defmodule ErlefWeb.AcademicPaperControllerTest do
  use ErlefWeb.ConnCase

  test "GET /academic-papers", %{conn: conn} do
    conn = get(conn, Routes.academic_paper_path(conn, :index))

    html =
      conn
      |> html_response(200)
      |> Floki.parse_document!()

    assert "Academic Papers" ==
             html
             |> Floki.find("h1")
             |> Floki.text()
  end
end
