# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :erlef, ErlefWeb.Endpoint,
  secret_key_base: "oVk/4INcsrNqubFeQp+ITcuCKloeA6gCqo/hHzHDSW4xwYt1bZQss6jLFcXpBNEU",
  render_errors: [view: ErlefWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Erlef.PubSub,
  live_view: [
    signing_salt: "Rz9o2n4vSG7hVWhCaqcF2IxvUURVFV8B"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# paths are implicitly priv
config :erlef, :repo_imports, [
  {"/posts/**/*.md", Erlef.Blog.Post}
]

config :erlef, :slack_teams, ["erlanger", "lfe", "luerl"]

config :erlef, :slack_invite_config, %{
  "erlanger" => %{
    token_key: "ERLANG_SLACK_API_TOKEN",
    team_key: "ERLANG_SLACK_TEAM_ID",
    channel_key: "ERLANG_SLACK_GENERAL_CHANNEL_ID"
  },
  "lfe" => %{
    token_key: "LFE_SLACK_API_TOKEN",
    team_key: "LFE_SLACK_TEAM_ID",
    channel_key: "LFE_SLACK_GENERAL_CHANNEL_ID"
  },
  "luerl" => %{
    token_key: "LUERL_SLACK_API_TOKEN",
    team_key: "LUERL_SLACK_TEAM_ID",
    channel_key: "LUERL_SLACK_GENERAL_CHANNEL_ID"
  }
}

config :erlef,
  ecto_repos: [Erlef.Repo]

config :ex_aws,
  s3: [
    scheme: "https://",
    region: "New Jersey",
    host: "ewr1.vultrobjects.com"
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
