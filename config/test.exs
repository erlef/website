import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.

config :erlef,
  secret: "UFxcBGAa6OnsKUezTOCmSDg+yr2K9Dmd8Lq9EM/vZalBsoaUmlWjmmwWFmJ6EItl"

config :erlef, ErlefWeb.Endpoint,
  http: [port: 4002],
  server: false

config :erlef, :env, :test

config :erlef, Erlef.Mailer, adapter: Swoosh.Adapters.Test

config :erlef, :wild_apricot_base_api_url, "http://127.0.0.1:9999"
config :erlef, :wild_apricot_base_auth_url, "http://127.0.0.1:9999"

# Print only warnings and errors during test
config :logger, level: :warning

config :erlef, :twitter_client, Erlef.ExTwitterTest

config :erlef, :domain, "localhost"

config :erlef, :wild_apricot,
  base_api_url: "http://127.0.0.1:9999",
  base_auth_url: "http://127.0.0.1:9999",
  account_id: "account_id",
  api_key: "api_key",
  client_id: "client_id",
  client_secret: "client_secret"

config :ex_aws,
  access_key_id: ["access_key_id", :instance_role],
  secret_access_key: ["secret_access_key", :instance_role],
  s3: [
    scheme: "http://",
    region: "New Jersey",
    host: "127.0.0.1",
    port: 9998
  ]

config :erlef, Erlef.Repo,
  database: "erlef_website_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  migration_primary_key: [id: :uuid, type: :binary_id],
  migration_timestamps: [type: :utc_datetime]

config :honeybadger,
  environment_name: :test,
  api_key: "test",
  exclude_envs: [:test]

config :erlef, api_key: "key"
