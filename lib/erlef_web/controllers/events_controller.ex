defmodule ErlefWeb.EventController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Events

  def index(conn, _params) do
    render(conn, events: Jason.encode!(all_events()))
  end


  defp all_events do 
     Enum.map(Events.Repo.all(), fn e -> Map.drop(e.metadata, ["author", "datetime", "slug"]) end)
  end
end
