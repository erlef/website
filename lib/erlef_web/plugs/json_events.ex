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
    events =
      Enum.map(Erlef.Events.Repo.all(), fn e ->
        slug = e.metadata["slug"]

        description =
          case String.length(e.body) > 260 do
            true -> String.slice(e.body, 0..260) <> "..."
            false -> e.body
          end

        e.metadata
        |> Map.put("url", "/events/#{slug}")
        |> Map.put("description", description)
      end)

    {events, Jason.encode!(events)}
  end
end
