defmodule ErlefWeb.EventController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.{Event, Posts}

  def index(conn, _params) do
    render(conn)
  end

  def show(conn, %{"id" => id}) do
    {:ok, event} = Posts.get_by_slug(Event, id)
    render(conn, event: event)
  end
end
