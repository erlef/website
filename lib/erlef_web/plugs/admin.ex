defmodule ErlefWeb.Plug.RequiresAdmin do
  @moduledoc """
  ErlefWeb.Plug.RequiresAdmin - Redirects a conn unless the user is an admin
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    session = get_session(conn, :member_session)

    case Erlef.Session.normalize(session) do
      %{is_admin: true} ->
        conn

      _ ->
        conn
        |> Phoenix.Controller.redirect(to: "/")
        |> Plug.Conn.halt()
    end
  end
end
