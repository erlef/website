defmodule ErlefWeb.Plug.JsonEvents do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default), do: assign(conn, :events, all_events())

  defp all_events do
    events =
      Enum.map(Erlef.Events.Repo.all(), fn e ->
        slug = e.metadata["slug"]
        Map.put(e.metadata, "url", "/events/#{slug}")
      end)

    Jason.encode!(events)
  end
end
