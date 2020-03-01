import Config

config :erlef, ErlefWeb.Endpoint,
  server: true,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443],
  check_origin: [
    "https://erlang.com",
    "https://erlang.com",
    "https://erlang.org",
    "https://www.erlang.org",
    "https://" <> System.get_env("APP_NAME") <> ".gigalixirapp.com"
  ]
