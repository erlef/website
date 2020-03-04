defmodule ErlefWeb.Admin.EventController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController
  alias Erlef.Data.Schema.Event
  alias Erlef.Data.Query.Event, as: Query
  alias Erlef.Events

  def index(conn, _params) do
    events = Erlef.Data.Query.Event.unapproved()
    render(conn, unapproved_events: events)
  end

  def show(conn, %{"id" => id}) do
    event = Query.get(id)
    name = Erlef.Members.get_display_name(50_769_064)
    render(conn, changeset: Event.new_changeset(event, %{}), event: %{event | submitted_by: name})
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
