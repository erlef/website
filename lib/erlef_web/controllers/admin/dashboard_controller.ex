defmodule ErlefWeb.Admin.DashboardController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Query.Event, as: Query
  alias Erlef.Members

  def index(conn, _params) do
    render(conn,
      outstanding_email_requests_count: Members.outstanding_email_requests_count(),
      unapproved_event_count: Query.unapproved_count()
    )
  end
end
