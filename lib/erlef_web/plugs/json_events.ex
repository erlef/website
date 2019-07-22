defmodule ErlefWeb.Plug.JsonEvents do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default), do: assign(conn, :events, all_events())

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

    Jason.encode!(events)
  end
end
