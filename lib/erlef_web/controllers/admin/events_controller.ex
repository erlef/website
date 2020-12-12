defmodule ErlefWeb.Admin.EventController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController
  alias Erlef.{Accounts, Community}

  def index(conn, _params) do
    events = Community.unapproved_events()
    render(conn, unapproved_events: events)
  end

  def show(conn, %{"id" => id}) do
    event = Community.get_event(id)
    {:ok, member} = Accounts.get_member(event.submitted_by)

    render(conn,
      changeset: Erlef.Community.change_event(event),
      event: %{event | submitted_by: member}
    )
  end

  def approve(conn, %{"id" => id, "event" => params}) do
    case Community.approve_event(id, params) do
      {:ok, _} ->
        redirect(conn, to: "/admin/events")

      {:error, cs} ->
        render(conn, changeset: cs, event: cs.data)
    end
  end
end
