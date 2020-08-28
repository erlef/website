import Config

config :erlef, ErlefWeb.Endpoint,
  server: true,
  http: [port: {:system, "PORT"}],
  url: [host: "erlef.org", port: 443],
  check_origin: [
    "//erlef.com",
    "//www.erlef.com",
    "//erlef.org",
    "//www.erlef.org"
  ]
