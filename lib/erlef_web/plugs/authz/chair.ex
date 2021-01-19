defmodule ErlefWeb.Plug.Authz.Chair do
  @moduledoc false

  # Depends in ErlefWeb.Plug.WorkingGroup

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case Map.get(conn.assigns, :is_chair) do
      true ->
        conn

      _ ->
        conn
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()
    end
  end
end
