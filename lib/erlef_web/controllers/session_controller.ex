defmodule ErlefWeb.SessionController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  @spec show(Plug.Conn.t(), map()) :: no_return()
  def show(conn, _params) do
    uri = Erlef.Session.login_uri()
    redirect(conn, external: uri)
  end

  def create(conn, %{
        "code" => auth_code,
        "state" => state
      }) do
    case Erlef.Session.login(auth_code, state) do
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
    :ok = Erlef.Session.logout(conn.assigns.current_user)

    conn
    |> delete_session("member_session")
    |> redirect(to: "/")
  end
end
