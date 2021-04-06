defmodule ErlefWeb.EventsLive.Index do
  use ErlefWeb, :live_view

  alias Erlef.Community

  import ErlefWeb.ViewHelpers, only: [event_dates: 2]

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:events, Community.approved_events())
      |> assign(:filter, "")

    {:ok, socket}
  end

  def handle_event("filter", %{"filter" => "ALL"}, socket) do
    socket = assign(socket, :filter, "")
    {:noreply, assign(socket, :events, Community.approved_events())}
  end

  def handle_event("filter", %{"filter" => filter}, socket) do
    events = Community.approved_events() |> Enum.filter(&(Atom.to_string(&1.type) == filter))

    socket =
      socket
      |> assign(:events, events)
      |> assign(:filter, filter)

    {:noreply, socket}
  end

  @spec active_class(String.t(), String.t()) :: String.t()
  defp active_class(selected, link_type) when selected == link_type, do: "active"
  defp active_class(_selected, _link_type), do: ""
end
