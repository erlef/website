defmodule Erlef.Data.Repo do
  use Ecto.Repo,
    otp_app: :erlef,
    adapter: Ecto.Adapters.Postgres
end
