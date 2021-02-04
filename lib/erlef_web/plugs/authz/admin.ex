defmodule ErlefWeb.Plug.Authz.Admin do
  @moduledoc """
  ErlefWeb.Plug.RequiresAdmin - Redirects a conn unless the user is an admin
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns.current_user do
      %{is_app_admin: true} ->
        conn

      _ ->
        conn
        |> Phoenix.Controller.redirect(to: "/")
        |> Plug.Conn.halt()
    end
  end
end
