defmodule Erlef.Repo do
  use Ecto.Repo,
    otp_app: :erlef,
    adapter: Ecto.Adapters.Postgres

  @spec count(Ecto.Schema.t(), Keyword.t()) :: integer() | nil
  def count(schema, opts \\ []) do
    aggregate(schema, :count, opts)
  end
end
