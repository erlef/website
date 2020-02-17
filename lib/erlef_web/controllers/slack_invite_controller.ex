defmodule ErlefWeb.SlackInviteController do
  use ErlefWeb, :controller

  action_fallback ErlefWeb.FallbackController

  @supported_teams Application.get_env(:erlef, :slack_teams)

  def index(conn, %{"team" => team}) when team in @supported_teams do
    render(conn, team: team, created: false, recaptcha_site_key: recaptcha_site_key())
  end

  def index(conn, _params) do
    msg =
      "This slack team is not supported. Please contact infra@erlef.org if you believe this is an error."

    conn
    |> put_flash(:error, msg)
    |> redirect(to: "/")
  end

  def create(conn, %{"email" => email, "g-recaptcha-response" => recaptcha_token, "team" => team}) do
    with {:ok, :verified} <- Erlef.Captcha.verify_recaptcha(recaptcha_token),
         {:ok, :invited} <- Erlef.SlackInvite.invite(email, team: team) do
      conn
      |> put_flash(:success, success_msg())
      |> redirect(to: "/")
    else
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> render("index.html",
          created: false,
          team: team,
          recaptcha_site_key: recaptcha_site_key()
        )
    end
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, "<h3>Whoops, you did something very wrong 🤔</h3>")
    |> redirect(to: "/")
  end

  defp recaptcha_site_key, do: System.get_env("RECAPTCHA_SITE_KEY")

  defp success_msg, do: "<h3>Keep your 👀 peeled for an invitation email ...</h3>"
end
