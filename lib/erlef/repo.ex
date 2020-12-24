defmodule Erlef.Repo do
  use Ecto.Repo,
    otp_app: :erlef,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query

  @spec count(Ecto.Schema.t()) :: integer() | nil
  def count(schema) do
    q =
      from(s in schema,
        select: count(s.id)
      )

    one(q)
  end
end
