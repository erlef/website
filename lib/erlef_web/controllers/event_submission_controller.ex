defmodule ErlefWeb.EventSubmissionController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  def create(conn, params) do
    redirect(conn, to: "/event_submissions/pending")
  end

  def index(conn, _params) do
    render(conn)
  end

  def show(conn, _params) do
    render(conn)
  end
end
