defmodule ErlefWeb.Plug.Session do
  @moduledoc """
  Erlef.Plug.Session - handles session refresh and expiration
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    maybe_set_session(conn, session(conn))
  end

  defp maybe_set_session(conn, nil), do: assign(conn, :current_user, nil)

  defp maybe_set_session(conn, session) do
    case Erlef.Session.expired?(session) do
      true ->
        purge_session(conn, session)

      false ->
        conn
        |> maybe_refresh_token(session)
        |> assign(:current_user, session)
    end
  end

  defp maybe_refresh_token(conn, session) do
    case Erlef.Session.should_refresh?(session) do
      true ->
        case Erlef.Session.refresh(session) do
          {:ok, new} ->
            store_session(conn, new)

          _ ->
            {:error, :unknown}
        end

      _ ->
        conn
    end
  end

  defp session(conn) do
    get_session(conn, "member_session") |> Erlef.Session.normalize()
  end

  defp store_session(conn, session) do
    conn
    |> configure_session(renew: true)
    |> put_session("member_session", session)
  end

  defp purge_session(conn, session) do
    Erlef.Session.logout(session)

    conn
    |> delete_session("member_session")
    |> assign(:current_user, nil)
    |> Phoenix.Controller.redirect(to: "/")
    |> halt()
  end
end
