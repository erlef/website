defmodule ErlefWeb.EventsLive do
  @moduledoc """
  Live view for events. Handles the filtering event
  """
  use Phoenix.LiveView

  alias Erlef.Community

  def mount(_params, %{"events" => events}, socket) do
    socket =
      socket
      |> assign(:events, events)
      |> assign(:filter, "")

    {:ok, socket}
  end

  def render(assigns) do
    ErlefWeb.EventView.render("_events.html", assigns)
  end

  def handle_event("filter", %{"filter" => "ALL"}, socket) do
    socket = assign(socket, :filter, "")
    {:noreply, assign(socket, :events, Community.approved_events())}
  end

  def handle_event("filter", %{"filter" => filter}, socket) do
    events = Community.approved_events() |> Enum.filter(&(&1.event_type.name == filter))

    socket =
      socket
      |> assign(:events, events)
      |> assign(:filter, filter)

    {:noreply, socket}
  end
end
