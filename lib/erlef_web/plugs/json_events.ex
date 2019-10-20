defmodule ErlefWeb.Plug.JsonEvents do
  import Plug.Conn
  alias Erlef.{Event, Posts}

  @moduledoc """
    Erlef.Plug.JsonEvents
  """

  def init(default), do: default

  def call(conn, _default) do
    {events, events_json} = all_events()

    conn
    |> assign(:events_json, events_json)
    |> assign(:events, events)
  end

  defp all_events do
    unsorted = Posts.all(Event)

    events =
      Enum.map(sort_by_datetime(unsorted), fn e ->
        slug = e.slug

        description =
          case String.length(e.body) > 260 do
            true -> String.slice(e.body, 0..260) <> "..."
            false -> e.body
          end

        e
        |> Map.from_struct()
        |> Map.delete(:__meta__)
        |> stringify_keys()
        |> Map.put("start", apply_time_offset(e.start, e.offset))
        |> Map.put("end", apply_time_offset(e.end, e.offset))
        |> Map.put("url", "/events/#{slug}")
        |> Map.put("description", description)
      end)

    {sort_by_datetime(unsorted), Jason.encode!(events)}
  end

  def stringify_keys(%{} = map) do
    map
    |> Enum.map(fn {k, v} -> {Atom.to_string(k), v} end)
    |> Enum.into(%{})
  end

  # Walk the list and stringify the keys of
  # of any map members
  def stringify_keys([head | rest]) do
    [stringify_keys(head) | stringify_keys(rest)]
  end

  defp sort_by_datetime(events) do
    Enum.sort(
      events,
      fn d1, d2 ->
        Date.compare(d1.start, d2.start) == :lt
      end
    )
  end

  defp apply_time_offset(datetime, "UTC" <> offset) when offset != "" do
    {offset_hours, _} = Integer.parse(offset)

    datetime
    |> Timex.shift(hours: offset_hours)
    |> DateTime.to_iso8601()
  end

  defp apply_time_offset(date_str, _), do: date_str
end
