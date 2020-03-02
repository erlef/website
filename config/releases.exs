import Config

config :erlef, ErlefWeb.Endpoint,
  server: true,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443],
  check_origin: [
    "//erlef.com",
    "//www.erlef.com",
    "//erlef.org",
    "//www.erlef.org",
    "//" <> System.get_env("APP_NAME") <> ".gigalixirapp.com"
  ]
