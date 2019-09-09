defmodule ErlefWeb.EventController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Events

  def index(conn, _params) do
    render(conn,
      gcal_api_key: Application.get_env(:erlef, :gcal_api_key),
      gcal_id: Application.get_env(:erlef, :gcal_id)
    )
  end

  def show(conn, %{"id" => id}) do
    {:ok, event} = Events.Repo.get(id)
    render(conn, event: event)
  end
end
