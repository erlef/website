defmodule ErlefWeb.EventController do
  use ErlefWeb, :controller

  alias Erlef.Community

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, events: Community.approved_events())
  end

  def show(conn, %{"slug" => slug}) do
    render(conn, event: Community.get_event_by_slug(slug))
  end
end
