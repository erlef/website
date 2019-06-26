defmodule ErlefWeb.PageController do
  use ErlefWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
