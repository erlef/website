defmodule ErlefWeb.EventController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Event

  def index(conn, _params) do
    gcal_api_key = System.get_env("GCAL_API_KEY")
    gcal_id = System.get_env("GCAL_ID")

    render(conn, events: Jason.encode!(Event.list()), gcal_api_key: gcal_api_key, gcal_id: gcal_id)
  end

end
