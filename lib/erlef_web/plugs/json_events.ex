defmodule ErlefWeb.Plug.JsonEvents do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    {events, events_json} = all_events()

    conn
    |> assign(:events_json, events_json)
    |> assign(:events, events)
  end

  defp all_events do
    unsorted = Erlef.Events.Repo.all()

    events =
      Enum.map(sort_by_datetime(unsorted), fn e ->
        slug = e.metadata["slug"]

        description =
          case String.length(e.body) > 260 do
            true -> String.slice(e.body, 0..260) <> "..."
            false -> e.body
          end

        e.metadata
        |> Map.put("start", apply_time_offset(e.metadata["start"], e.metadata["offset"]))
        |> Map.put("end", apply_time_offset(e.metadata["end"], e.metadata["offset"]))
        |> Map.put("url", "/events/#{slug}")
        |> Map.put("description", description)
      end)

    {events, Jason.encode!(events)}
  end

  defp sort_by_datetime(events) do
    Enum.sort(
      events,
      fn d1, d2 ->
        Date.compare(from_iso8601(d1), from_iso8601(d2)) == :lt
      end
    )
  end

  defp apply_time_offset(date_str, "UTC" <> offset) when offset != "" do
    {:ok, datetime, _} = DateTime.from_iso8601(date_str)
    {offset_hours, _} = Integer.parse(offset)

    datetime
    |> Timex.shift(hours: offset_hours)
    |> DateTime.to_iso8601()
  end

  defp apply_time_offset(date_str, _), do: date_str

  defp from_iso8601(d) do
    {:ok, dt, _} = DateTime.from_iso8601(d.metadata["start"])
    dt
  end
end
