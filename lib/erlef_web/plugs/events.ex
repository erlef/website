defmodule ErlefWeb.Plug.Events do
  import Plug.Conn
  alias Erlef.{Event, Posts}

  @moduledoc """
    Erlef.Plug.Events injects events sourced from markdown so that the list of events
  is made available to any view.
  """

  def init(default), do: default

  def call(conn, _default) do
    conn
    |> assign(:events, all_events())
  end

  defp all_events do
    Event
    |> Posts.all()
    |> sort_by_datetime()
  end

  defp sort_by_datetime(events) do
    Enum.sort(
      events,
      fn d1, d2 ->
        Date.compare(d1.start, d2.start) == :lt
      end
    )
  end
end
