use Mix.Config

config :erlef, ErlefWeb.Endpoint,
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_origin: [
    "//erlef.com",
    "//erlef.com",
    "//erlef.org",
    "//erlef.org",
    "//" <> System.get_env("APP_NAME") <> ".gigalixirapp.com"
  ]

# Do not print debug messages in production
config :logger, level: :info

config :erlef, Erlef.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "mail.privateemail.com",
  ssl: true,
  tls: :if_available,
  auth: :always,
  port: 465,
  retries: 2,
  no_mx_lookups: false

config :erlef, env: :prod

config :erlef, ErlefWeb.Endpoint, force_ssl: [hsts: true, rewrite_on: [:x_forwarded_proto]]

config :erlef,
       Erlef.Data.Repo,
       url: System.get_env("DATABASE_URL"),
       pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
       migration_primary_key: [id: :uuid, type: :binary_id],
       migration_timestamps: [type: :utc_datetime],
       ssl: true

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :erlef, ErlefWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         :inet6,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :erlef, ErlefWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :erlef, ErlefWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

# Finally import the config/prod.secret.exs which loads secrets
# and configuration from environment variables.
import_config "prod.secret.exs"
