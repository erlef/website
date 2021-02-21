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
        |> maybe_return_to()

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

  @spec maybe_redirect(any()) :: no_return()
  defp maybe_redirect(conn) do
    uri = Erlef.Session.login_uri()
    redirect(conn, external: uri)
  end

  defp maybe_return_to(conn) do
    case get_session(conn, :return_to) do
      nil ->
        redirect(conn, to: "/")

      path ->
        conn
        |> put_session(:return_to, nil)
        |> redirect(to: path)
    end
  end
end
