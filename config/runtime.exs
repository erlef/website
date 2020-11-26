import Config

## General runtime config required for use in all environments

# TODO: Refactor so that this is only required in staging/prod

config :extwitter, :oauth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
  access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
  access_token_secret: System.get_env("TWITTER_ACCESS_TOKEN_SECRET")

# TODO: Refactor so that this is only required in staging/prod
config :ex_aws,
  access_key_id: [System.get_env("VULTR_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.get_env("VULTR_SECRET_KEY_ID"), :instance_role]

if Application.get_env(:erlef, :env) == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  url_port =
    System.get_env("URL_PORT") ||
      raise """
      environment variable URL_PORT is missing.
      The value of this port should reflect the port 
      that clients will use to connect to the site (e.g., 443).
      """

  port = String.to_integer(System.get_env("PORT") || "4000")

  domain =
    System.get_env("ERLEF_DOMAIN") ||
      raise """
      environment variable ERLEF_DOMAIN is missing.
      ERLEF_DOMAIN should be set to the value clients
      will connect to the application (e.g., erlef.org)
      """

  database =
    System.get_env("DATABASE") ||
      raise """
      environment variable DATABASE is missing"
      """

  database_user =
    System.get_env("DATABASE_USER") ||
      raise """
      environment variable DATABASE_USER is missing"
      """

  database_password =
    System.get_env("DATABASE_PASSWORD") ||
      raise """
      environment variable DATABASE_PASSWORD is missing"
      """

  pool_size = String.to_integer(System.get_env("POOL_SIZE") || "10")

  config :erlef, ErlefWeb.Endpoint,
    http: [:inet6, port: port],
    secret_key_base: secret_key_base,
    server: true,
    http: [port: port],
    url: [host: domain, port: url_port],
    check_origin: [
      "//#{domain}",
      "//www.#{domain}"
    ]

  config :erlef,
         Erlef.Data.Repo,
         database: database,
         username: database_user,
         password: database_password,
         pool_size: pool_size,
         migration_primary_key: [id: :uuid, type: :binary_id],
         migration_timestamps: [type: :utc_datetime],
         ssl: false

  smtp_relay_host =
    System.get_env("SMTP_RELAY_HOST") ||
      raise """
      environment variable SMTP_RELAY_HOST is missing.
      """

  config :erlef, Erlef.Mailer,
    adapter: Swoosh.Adapters.SMTP,
    relay: smtp_relay_host,
    ssl: true,
    auth: :always,
    port: 465,
    retries: 2,
    no_mx_lookups: false
end
