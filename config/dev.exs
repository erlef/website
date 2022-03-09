use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :erlef,
  secret: "UFxcBGAa6OnsKUezTOCmSDg+yr2K9Dmd8Lq9EM/vZalBsoaUmlWjmmwWFmJ6EItl"

config :erlef, ErlefWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch",
      "--watch-options-stdin",
      cd: "assets",
      env: [{"TAILWIND_MODE", "watch"}]
    ]
  ]

# Watch static and templates for browser reloading.
config :erlef, ErlefWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"priv/data/community/.*(exs)$",
      ~r"priv/data/.*(exs)$",
      ~r"lib/erlef/community/.*(ex)$",
      ~r"lib/erlef_web/{live,views}/.*(ex)$",
      ~r"lib/erlef_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :erlef, Erlef.Mailer, adapter: Swoosh.Adapters.Local

config :erlef, env: :dev

config :erlef, :twitter_client, Erlef.Twitter

config :swoosh, preview_port: 4001

# A model (fake server) of the wildapricot api is used in dev / test mode
# See test/support/models/wild_apricot.ex for details

config :erlef, :domain, "localhost"

config :erlef, :wild_apricot,
  base_api_url: "http://127.0.0.1:9999",
  base_auth_url: "http://127.0.0.1:9999",
  account_id: "account_id",
  api_key: "api_key",
  client_id: "client_id",
  client_secret: "client_secret"

config :erlef, Erlef.Repo,
  database: "erlef_website_dev",
  username: "postgres",
  password: "postgres",
  migration_primary_key: [id: :uuid, type: :binary_id],
  migration_timestamps: [type: :utc_datetime],
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# ExTwitter is not used in dev or test mode, but we set the config here for good measure
# to fake credentials
config :extwitter, :oauth,
  consumer_key: "consumer_key",
  consumer_secret: "consumer_secret",
  access_token: "access_token",
  access_token_secret: "access_token_secret"

config :ex_aws,
  access_key_id: ["access_key_id", :instance_role],
  secret_access_key: ["secret_access_key", :instance_role],
  s3: [
    scheme: "http://",
    region: "New Jersey",
    host: "127.0.0.1",
    port: 9998
  ]

config :honeybadger,
  environment_name: :dev,
  api_key: "dev",
  exclude_envs: [:dev]

config :erlef, api_key: "key"

config :erlef, :conference_perks, %{
  code_beam_v_2021: %{
    ends: ~D[2021-03-13],
    discount: %{
      link: "https://foo.bar/",
      starts: ~D[2021-03-07],
      ends: ~D[2021-03-13]
    },
    keynote: %{
      link: "https://foo.bar/",
      starts: ~U[2021-03-11 21:30:00.000000Z],
      ends: ~U[2021-03-11 22:10:00.000000Z]
    },
    bof: %{
      link: "https://foo.bar/",
      starts: ~U[2021-03-11 22:10:00.000000Z],
      ends: ~U[2021-03-11 23:10:00.000000Z]
    }
  }
}
