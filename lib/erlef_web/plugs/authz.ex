defmodule ErlefWeb.Plug.Authz do
  @moduledoc """
  ErlefWeb.Plug.Authz - Redirects a conn unless the user is logged in
  """

  import Plug.Conn
  alias Erlef.Accounts.Member

  def init(opts), do: opts

  def call(conn, _opts) do
    case {get_session(conn, :member_session), Map.get(conn.assigns, :current_user)} do
      {_, nil} -> redirect(conn)
      {nil, _} -> redirect(conn)
      {%{}, %Member{}} -> conn
    end
  end

  defp redirect(conn) do
    conn
    |> Phoenix.Controller.put_flash(:notice, error_msg())
    |> Phoenix.Controller.redirect(to: "/")
    |> Plug.Conn.halt()
  end

  defp error_msg do
    msg = "The resource you requested requires that you are logged in."
    link = "https://members.erlef.org/join-us"

    "<h3 class='text-center'>#{msg}</h3><p class='text-center'>Don't have a login? <a href='#{
      link
    }'>Join us!</a></p>"
  end
end
