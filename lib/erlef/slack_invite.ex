defmodule Erlef.SlackInvite do
  def invite(email, team: team) do
    slack_config = Application.get_env(:erlef, :slack_invite_config)
    team_env_keys = slack_config[team]
    token = System.get_env(team_env_keys.token_key)
    team_id = System.get_env(team_env_keys.team_key)
    channel_id = System.get_env(team_env_keys.channel_key)

    url =
      :hackney_url.make_url("https://slack.com", "/api/users.admin.invite", [
        {"token", token},
        {"email", email},
        {"team", team_id},
        {"channels", channel_id}
      ])

    with {:ok, 200, _headers, ref} <- :hackney.post(url),
         {:ok, body} <- :hackney.body(ref),
         {:ok, res} <- Jason.decode(body) do
      map_res(res)
    end
  end

  defp map_res(res) do
    case res do
      %{"ok" => true} -> {:ok, :invited}
      %{"error" => reason} -> {:error, format_error(reason)}
    end
  end

  defp format_error("already_in_team_invited_user") do
    "A slack invite already exists for the provided email address"
  end

  defp format_error("already_invited") do
    "A slack invite already exists for the provided email address"
  end

  defp format_error("invalid_email") do
    "The email address provided appears to be invalid. Please use another email address"
  end

  defp format_error(_) do
    "An unknown error has occured. Please contact infra@erlef.org for assistance"
  end
end
