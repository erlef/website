defmodule ErlefWeb.Admin.EventController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController
  alias Erlef.Query.Event, as: Query
  alias Erlef.Events

  def index(conn, _params) do
    events = Query.unapproved()
    render(conn, unapproved_events: events)
  end

  def show(conn, %{"id" => id}) do
    event = Query.get(id)
    {:ok, member} = Erlef.Accounts.get_member(event.submitted_by)

    render(conn,
      changeset: nil,
      event: %{event | submitted_by: member}
    )
  end

  def approve(conn, %{"id" => id, "event" => params}) do
    case Events.approve(id, params) do
      {:ok, _} ->
        redirect(conn, to: "/admin/events")

      {:error, cs} ->
        render(conn, changeset: cs, event: cs.data)
    end
  end
end
