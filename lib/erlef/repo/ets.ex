defmodule Erlef.Repo.ETS do
  @moduledoc false
  use Ecto.Repo, otp_app: :erlef, adapter: Etso.Adapter
end
