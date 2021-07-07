defmodule ErlefWeb.EventController do
  use ErlefWeb, :controller

  alias Erlef.Community

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, events: Community.approved_events())
  end
end
