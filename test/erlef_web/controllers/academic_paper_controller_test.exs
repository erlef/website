defmodule ErlefWeb.AcademicPaperControllerTest do
  use ErlefWeb.ConnCase
  import Phoenix.LiveViewTest
  @endpoint ErlefWeb.Endpoint

  setup do
    beam =
      insert_list(3, :academic_papers, %{technologies: ["BEAM"], published_at: DateTime.utc_now()})

    erlang =
      insert_list(2, :academic_papers, %{
        technologies: ["Erlang"],
        published_at: DateTime.utc_now()
      })

    elixir =
      insert_list(1, :academic_papers, %{
        technologies: ["Elixir"],
        published_at: DateTime.utc_now()
      })

    {:ok, %{academic_papers: beam ++ erlang ++ elixir}}
  end

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

  test "GET /academic-papers live view filtering", %{conn: conn, academic_papers: academic_papers} do
    {:ok, view, html} =
      live_isolated(conn, ErlefWeb.AcademicPapersLive,
        session: %{"academic_papers" => academic_papers}
      )

    # Inital page load
    assert 6 ==
             html
             |> Floki.parse_document!()
             |> Floki.find(".event-card")
             |> Enum.count()

    # Filters after page load
    assert 3 == count_event_cards(view, "BEAM")
    assert 2 == count_event_cards(view, "Erlang")
    assert 1 == count_event_cards(view, "Elixir")
    assert 6 == count_event_cards(view, "ALL")
  end

  defp count_event_cards(view, filter) do
    view
    |> render_click(:filter, %{"filter" => filter})
    |> Floki.parse_document!()
    |> Floki.find(".event-card")
    |> Enum.count()
  end
end
