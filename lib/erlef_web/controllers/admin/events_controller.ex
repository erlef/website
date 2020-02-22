defmodule ErlefWeb.Admin.EventController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.{Event, Posts}

  def index(conn, _params) do
    render(conn,
      gcal_api_key: System.get_env("GCAL_API_KEY"),
      gcal_id: System.get_env("GCAL_ID")
    )
  end

  def show(conn, %{"id" => id}) do
    {:ok, event} = Posts.get_by_slug(Event, id)
    render(conn, event: event)
  end
end
