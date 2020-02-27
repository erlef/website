use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :erlef, ErlefWeb.Endpoint,
  http: [port: 4002],
  server: false

config :erlef, :env, :test

config :erlef, Erlef.Mailer, adapter: Swoosh.Adapters.Test

config :erlef, :wild_apricot_base_api_url, "http://127.0.0.1:9999"
config :erlef, :wild_apricot_base_auth_url, "http://127.0.0.1:9999"

# Print only warnings and errors during test
config :logger, level: :warn

config :erlef, Erlef.Data.Repo,
  database: "erlef_website_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  migration_primary_key: [id: :uuid, type: :binary_id],
  migration_timestamps: [type: :utc_datetime]
