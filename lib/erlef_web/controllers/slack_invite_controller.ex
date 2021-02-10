defmodule ErlefWeb.SlackInviteController do
  use ErlefWeb, :controller

  action_fallback ErlefWeb.FallbackController

  def index(conn, %{"team" => team}) do
    case team in Application.get_env(:erlef, :slack_teams) do
      true ->
        render(conn, team: team, created: false)

      false ->
        msg =
          "This slack team is not supported. Please contact infra@erlef.org if you believe this is an error."

        conn
        |> put_flash(:error, msg)
        |> redirect(to: "/")
    end
  end

  def create(conn, %{"email" => email, "team" => team}) do
    with {:ok, :valid} <- validate_email(email),
         {:ok, :invited} <- Erlef.SlackInvite.invite(email, team: team) do
      conn
      |> put_flash(:success, success_msg())
      |> redirect(to: "/")
    else
      {:error, error} ->
        conn
        |> put_flash(:error, format_error(error))
        |> render("index.html",
          created: false,
          team: team
        )
    end
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, "<h3>Whoops, you did something very wrong 🤔</h3>")
    |> redirect(to: "/")
  end

  defp success_msg, do: "<h3>Keep your 👀 peeled for an invitation email ...</h3>"

  defp validate_email(email) do
    case Erlef.Inputs.is_email?(email) do
      true -> {:ok, :valid}
      false -> {:error, :invalid_email}
    end
  end

  defp format_error(:invalid_email) do
    "Invalid email Address"
  end

  defp format_error(error), do: error
end
