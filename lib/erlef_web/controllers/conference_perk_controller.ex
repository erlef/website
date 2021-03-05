defmodule ErlefWeb.ConferencePerkController do
  use ErlefWeb, :controller

  action_fallback ErlefWeb.FallbackController

  def index(conn, %{"conference" => "code-beam-v-2021-america"}) do
    case conn.assigns.current_user do
      %Erlef.Accounts.Member{} ->
        redirect(conn, to: "/members/profile")

      _ ->
        render(conn, "login_required.html")
    end
  end

  def index(conn, _) do
    msg = "Unknown conference. Please contact infra@erlef.org if you believe this is an error."

    conn
    |> put_flash(:error, msg)
    |> redirect(to: "/")
  end
end
