defmodule Erlef do
  @moduledoc """
  Erlef keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def is_env?(env), do: Application.get_env(:erlef, :env) == env
end
