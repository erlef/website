defmodule ErlefWeb.Plug.Session do
  @moduledoc """
  Erlef.Plug.Session - handles session refresh and expiration
  """

  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    case session(conn) do
      %Erlef.Session{} = session ->
        set_session(conn, session)

      nil ->
        assign(conn, :current_user, nil)

      {:error, :timeout} ->
        msg =
          "There was a problem fetching your member details. Please refresh the page " <>
            " or try logging in again"

        conn
        |> Phoenix.Controller.put_flash(:info, msg)
        |> assign(:current_user, nil)

      err ->
        Logger.error(fn -> "Unexpected error while building session -> #{err}" end)
        assign(conn, :current_user, nil)
    end
  end

  defp set_session(conn, session) do
    case Erlef.Session.expired?(session) do
      true ->
        purge_session(conn, session)

      false ->
        conn
        |> maybe_refresh_token(session)
        |> assign(:current_session, session)
        |> assign(:current_user, session.member)
        |> maybe_assign_volunteer(session.member)
    end
  end

  defp maybe_assign_volunteer(conn, %{id: nil}) do
    assign(conn, :current_volunteer, nil)
  end

  defp maybe_assign_volunteer(conn, member) do
    case Erlef.Groups.get_volunteer_by_member_id(member.id) do
      %Erlef.Groups.Volunteer{} = vol ->
        assign(conn, :current_volunteer, vol)

      _ ->
        assign(conn, :current_volunteer, nil)
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
    get_session(conn, "member_session") |> Erlef.Session.build()
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
  end
end
