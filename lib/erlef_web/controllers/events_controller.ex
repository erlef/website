defmodule ErlefWeb.EventController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Events

  def index(conn, _params) do
    render(conn)
  end

  def show(conn, %{"id" => id}) do
    {:ok, event} = Erlef.Events.Repo.get(id)
    render(conn, event: event)
  end
end
