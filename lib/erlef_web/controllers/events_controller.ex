defmodule ErlefWeb.EventController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Events

  def index(conn, _params) do
    render(conn,
      gcal_api_key: System.get_env("GCAL_API_KEY"),
      gcal_id: System.get_env("GCAL_ID")
    )
  end

  def show(conn, %{"id" => id}) do
    {:ok, event} = Events.Repo.get(id)
    render(conn, event: event)
  end
end
