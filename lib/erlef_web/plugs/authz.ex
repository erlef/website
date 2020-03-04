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
        |> Phoenix.Controller.put_flash(:error, error_msg())
        |> Phoenix.Controller.redirect(to: "/")
        |> Plug.Conn.halt()

      _ ->
        conn
    end
  end

  defp error_msg do
    msg = "The resource you requested requires that you are logged in."
    link = "https://members.erlef.org/join-us"

    "<h3 class='text-center'>#{msg}</h3><p class='text-center'>Don't have a login? <a href='#{
      link
    }'>Join us!</a></p>"
  end
end
