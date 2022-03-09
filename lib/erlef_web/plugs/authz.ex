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
      {%{}, %Member{}} -> maybe_return_to(conn)
    end
  end

  defp maybe_return_to(conn) do
    case get_session(conn, :return_to) do
      nil ->
        conn

      path ->
        conn
        |> put_session(:return_to, nil)
        |> redirect_to(path)
    end
  end

  defp redirect(conn) do
    conn
    |> put_session(:return_to, conn.request_path)
    |> Phoenix.Controller.put_flash(:notice, error_msg())
    |> redirect_to("/")
  end

  defp redirect_to(conn, path) do
    conn
    |> Phoenix.Controller.redirect(to: path)
    |> Plug.Conn.halt()
  end

  defp error_msg do
    msg = "The resource you requested requires that you are logged in."
    link = "https://members.erlef.org/join-us"

    "<h3 class='text-center'>#{msg}</h3><p class='text-center'>Don't have a login? <a href='#{link}'>Join us!</a></p>"
  end
end
