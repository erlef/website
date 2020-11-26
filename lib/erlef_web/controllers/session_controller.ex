defmodule ErlefWeb.SessionController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  @spec show(Plug.Conn.t(), map()) :: no_return()
  def show(conn, _params) do
    maybe_redirect(conn)
  end

  def create(conn, %{"code" => auth_code}) do
    case Erlef.Session.login(auth_code) do
      {:ok, session} ->
        conn
        |> configure_session(renew: true)
        |> put_session("member_session", session)
        |> redirect(to: "/")

      _ ->
        create(conn, nil)
    end
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, "Invalid Login")
    |> redirect(to: "/")
  end

  def delete(conn, _params) do
    :ok = Erlef.Session.logout(conn.assigns.current_session)

    conn
    |> delete_session("member_session")
    |> redirect(to: "/")
  end

  defp maybe_redirect(conn) do
    uri = Erlef.Session.login_uri()
    redirect(conn, external: uri)
  end
end
