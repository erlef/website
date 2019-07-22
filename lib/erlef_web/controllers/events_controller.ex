defmodule ErlefWeb.EventController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Events

  def index(conn, _params) do
    render(conn)
  end

  def show(conn, _params) do
    render(conn, event: nil)
  end
end
