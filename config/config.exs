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
  pubsub: [name: Erlef.PubSub, adapter: Phoenix.PubSub.PG2],
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
  {"/posts/**/*.md", Erlef.Blog},
  {"/events/**/*.md", Erlef.Event},
  {"/working_groups/**/*.md", Erlef.WorkingGroup}
]

import_config "members.exs"
import_config "sponsors.exs"

config :erlef, :slack_teams, ["erlanger"]

config :erlef, :slack_invite_config, %{
  "erlanger" => %{
    token_key: "ERLANG_SLACK_API_TOKEN",
    team_key: "ERLANG_SLACK_TEAM_ID",
    channel_key: "ERLANG_SLACK_GENERAL_CHANNEL_ID"
  }
}

config :erlef, :wild_apricot_base_api_url, "https://api.wildapricot.org"
config :erlef, :wild_apricot_base_auth_url, "https://oauth.wildapricot.org"

config :erlef,
  ecto_repos: [Erlef.Data.Repo]

config :extwitter, :oauth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
  access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
  access_token_secret: System.get_env("TWITTER_ACCESS_TOKEN_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
