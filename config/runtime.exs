import Config

if Application.get_env(:erlef, :env) == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  erlef_secret =
    System.get_env("SECRET") ||
      raise """
      environment variable SECRET is missing.
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

  config :erlef, secret: erlef_secret

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
         Erlef.Repo,
         database: database,
         username: database_user,
         password: database_password,
         pool_size: pool_size,
         migration_primary_key: [id: :uuid, type: :binary_id],
         migration_timestamps: [type: :utc_datetime],
         ssl: false

  config :erlef, :domain, domain

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
    no_mx_lookups: false,
    username: {:system, "SMTP_USER"},
    password: {:system, "SMTP_PASSWORD"}

  config :extwitter, :oauth,
    consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
    consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
    access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
    access_token_secret: System.get_env("TWITTER_ACCESS_TOKEN_SECRET")

  config :ex_aws,
    access_key_id: [System.get_env("VULTR_ACCESS_KEY_ID"), :instance_role],
    secret_access_key: [System.get_env("VULTR_SECRET_KEY_ID"), :instance_role]

  wapi_account_id =
    System.get_env("WA_ACCOUNT_ID") ||
      raise """
      environment variable WA_ACCOUNT_ID is missing"
      """

  wapi_api_key =
    System.get_env("WAPI_API_KEY") ||
      raise """
      environment variable WAPI_API_KEY is missing"
      """

  wapi_client_id =
    System.get_env("WAPI_CLIENT_ID") ||
      raise """
      environment variable WAPI_CLIENT_ID is missing"
      """

  wapi_client_secret =
    System.get_env("WAPI_CLIENT_SECRET") ||
      raise """
      environment variable WAPI_CLIENT_SECRET is missing
      """

  config :erlef, :wild_apricot,
    base_api_url: "https://api.wildapricot.org",
    base_auth_url: "https://oauth.wildapricot.org",
    account_id: wapi_account_id,
    api_key: wapi_api_key,
    client_id: wapi_client_id,
    client_secret: wapi_client_secret

  gh_app_pem =
    System.get_env("GITHUB_APP_PEM") ||
      raise """
      environment variable GITHUB_APP_PEM is missing.
      """

  gh_app_id =
    System.get_env("GITHUB_APP_ID") ||
      raise """
      environment variable GITHUB_APP_ID is missing
      """

  gh_app_install_id =
    System.get_env("GITHUB_APP_INSTALL_ID") ||
      raise """
      environment variable GITHUB_APP_INSTALL_ID is missing
      """

  config :erlef, :github,
    app_install_id: gh_app_install_id,
    key_pem: gh_app_pem,
    app_id: gh_app_id

  report_submission_repo =
    System.get_env("ERLEF_REPORT_SUBMISSION_REPO") ||
      raise """
        environment variable ERLEF_REPORT_SUBMISSION_REPO is missing
      """

  config :erlef, :reports, report_submission_repo: report_submission_repo

  api_key =
    System.get_env("API_KEY") ||
      raise """
      environment variable API_KEY is missing"
      """

  config :erlef, api_key: api_key

  discount_link =
    System.get_env("CODE_BEAM_V_AMERICA_2021_DISCOUNT_LINK") ||
      raise """
      enviroment variable CODE_BEAM_V_AMERICA_2021_DISCOUNT_LINK
      """

  key_note_link =
    System.get_env("CODE_BEAM_V_AMERICA_2021_KEYNOTE_LINK") ||
      raise """
      enviroment variable CODE_BEAM_V_AMERICA_2021_KEYNOTE_LINK
      """

  bof_link =
    System.get_env("CODE_BEAM_V_AMERICA_2021_BOF_LINK") ||
      raise """
      enviroment variable CODE_BEAM_V_AMERICA_2021_BOF_LINK
      """

  config :erlef, :conference_perks, %{
    code_beam_v_2021: %{
      ends: ~D[2021-03-13],
      discount: %{
        link: discount_link,
        starts: ~D[2021-03-07],
        ends: ~D[2021-03-13]
      },
      keynote: %{
        link: key_note_link,
        starts: ~U[2021-03-11 21:30:00.000000Z],
        ends: ~U[2021-03-11 22:10:00.000000Z]
      },
      bof: %{
        link: bof_link,
        starts: ~U[2021-03-11 22:10:00.000000Z],
        ends: ~U[2021-03-11 23:10:00.000000Z]
      }
    }
  }

  bot_token =
    System.get_env("ERLEF_SLACK_BOT_TOKEN") ||
      raise """
      enviroment variable ERLEF_SLACK_BOT_TOKEN
      """

  erlef_slack_invite_channel =
    System.get_env("ERLEF_SLACK_INVITE_CHANNEL") ||
      raise """
      enviroment variable ERLEF_SLACK_INVITE_CHANNEL
      """

  config :erlef, :slack,
    bot_token: bot_token,
    invite_channel: erlef_slack_invite_channel

  config :logger,
    # or other Logger level,
    level: :info,
    backends: [LogflareLogger.HttpBackend]

  logflare_api_key =
    System.get_env("LOGFLARE_API_KEY") ||
      raise """
      enviroment variable LOGFLARE_API_KEY
      """

  logflare_source_id =
    System.get_env("LOGFLARE_SOURCE_ID") ||
      raise """
      enviroment variable LOGFLARE_SOURCE_ID
      """

  config :logflare_logger_backend,
    url: "https://api.logflare.app",
    level: :info,
    api_key: logflare_api_key,
    source_id: logflare_source_id,
    # minimum time in ms before a log batch is sent to the server ",
    flush_interval: 1_000,
    # maximum number of events before a log batch is sent to the server
    max_batch_size: 50
end
