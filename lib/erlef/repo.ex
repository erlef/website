defmodule Erlef.Repo do
  use Ecto.Repo, otp_app: :erlef, adapter: Etso.Adapter
end
