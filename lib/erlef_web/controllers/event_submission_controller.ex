defmodule ErlefWeb.EventSubmissionController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  def create(conn, %{"event" => params}) do
    case Erlef.Members.submit_event(params) do
      {:ok, _event} ->
        redirect(conn, to: "/event_submissions/pending")

      {:error, changeset} ->
        render(conn, "index.html", changeset: %{changeset | action: :insert})
    end
  end

  def index(conn, _params) do
    render(conn, changeset: Erlef.Members.new_event())
  end

  def show(conn, _params) do
    render(conn)
  end
end
