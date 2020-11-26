defmodule ErlefWeb.Admin.DashboardController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Query.Event, as: Query

  def index(conn, _params) do
    render(conn, unapproved_event_count: Query.unapproved_count())
  end
end
