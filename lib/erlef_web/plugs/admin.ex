defmodule ErlefWeb.Plug.RequiresAdmin do
  @moduledoc """
  ErlefWeb.Plug.RequiresAdmin - Redirects a conn unless the user is an admin
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :member_session) do
      %{member: %{is_app_admin?: true}} ->
        conn
      %{"member" => %{"is_app_admin?" => true}} ->
          conn
      _ ->
        conn
        |> Phoenix.Controller.redirect(to: "/")
        |> Plug.Conn.halt()
    end
  end
end
