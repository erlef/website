use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :erlef, ErlefWeb.Endpoint,
  http: [port: 4002],
  server: false

config :erlef, :env, :test

# Print only warnings and errors during test
config :logger, level: :warn
