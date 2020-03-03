defmodule ErlefWeb.Plug.Authz do
  @moduledoc """
  ErlefWeb.Plug.Authz - Redirects a conn unless the user is logged in
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :member_session) do
      nil ->
        conn
        |> Phoenix.Controller.redirect(to: "/")
        |> Plug.Conn.halt()

      _ ->
        conn
    end
  end
end
