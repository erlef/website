import Config

# See runtime.exs for more detail on production configuration

config :erlef, env: :prod

# Do not print debug messages in production
config :logger, level: :info
