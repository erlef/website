defmodule ErlefWeb.EventController do
  use ErlefWeb, :controller

  alias Erlef.Data.Query.Event, as: Query

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, events: Query.approved())
  end

  def show(conn, %{"slug" => slug}) do
    render(conn, event: Query.get_by_slug(slug))
  end
end
