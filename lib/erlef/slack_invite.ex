defmodule Erlef.SlackInvite do
  @moduledoc """
  Erlef.SlackInvite - Slack Invite API client
  """

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

  def send_to_erlef_slack_invite_channel(msg) do
    token = erlef_slack_bot_token()

    headers = [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{token}"}
    ]

    post("chat.postMessage", headers, %{channel: erlef_slack_invite_channel(), text: msg}, [])
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

  defp post(path, headers, body, opts) do
    case Erlef.HTTP.perform(:post, "https://slack.com/api/#{path}", headers, body, opts) do
      {:ok, %{body: body}} ->
        {:ok, body}

      err ->
        err
    end
  end

  defp erlef_slack_bot_token(), do: config_get(:bot_token)
  defp erlef_slack_invite_channel(), do: config_get(:invite_channel)

  defp config_get(key) do
    props = Application.get_env(:erlef, :slack)
    Keyword.get(props, key)
  end
end
