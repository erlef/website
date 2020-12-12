defmodule ErlefWeb.Admin.DashboardController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Community
  alias Erlef.Members

  def index(conn, _params) do
    render(conn,
      outstanding_email_requests_count: Members.outstanding_email_requests_count(),
      unapproved_event_count: Community.unapproved_events_count()
    )
  end
end
