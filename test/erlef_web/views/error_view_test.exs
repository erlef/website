defmodule ErlefWeb.ErrorViewTest do
  use ErlefWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  setup %{conn: conn} do
    conn = conn |> Plug.Conn.put_private(:phoenix_endpoint, ErlefWeb.Endpoint)
    [conn: conn]
  end

  test "renders 404.html", %{conn: conn} do
    expected = "Oops! Page not found"
    assert render_to_string(ErlefWeb.ErrorView, "404.html", conn: conn) =~ expected
  end

  test "renders 500.html", %{conn: conn} do
    expected = "Oops! Something went wrong"
    assert render_to_string(ErlefWeb.ErrorView, "500.html", conn: conn) =~ expected
  end
end
