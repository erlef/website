defmodule ErlefWeb.SessionController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  def show(conn, _params) do
    render(conn, "show.html", recaptcha_site_key: recaptcha_site_key())
  end

  def create(conn, %{
        "username" => user,
        "g-recaptcha-response" => recaptcha_token,
        "password" => password
      }) do
    with true <- Erlef.Inputs.is_email(user),
         {:ok, :verified} <- verify_captcha(recaptcha_token),
         {:ok, session} <- Erlef.Session.login(user, password) do
      conn
      |> configure_session(renew: true)
      |> put_session("member_session", session)
      |> redirect(to: "/")
    else
      _ ->
        create(conn, nil)
    end
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, "Invalid Login")
    |> render("show.html", recaptcha_site_key: recaptcha_site_key())
  end

  def delete(conn, _params) do
    :ok = Erlef.Session.logout(conn.assigns.current_user)

    conn
    |> delete_session("member_session")
    |> redirect(to: "/")
  end

  if Erlef.is_env?(:dev) do
    defp verify_captcha(_token), do: {:ok, :verified}
  else
    defp verify_captcha(token), do: Erlef.Captcha.verify_recaptcha(token)
  end
end
