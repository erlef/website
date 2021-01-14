defmodule ErlefWeb.Admin.DashboardController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn,
      resource_counts: Erlef.Admins.resource_counts()
    )
  end
end
