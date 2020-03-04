defmodule ErlefWeb.Admin.DashboardController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, unapproved_event_count: Erlef.Data.Query.Event.unapproved_count())
  end
end
