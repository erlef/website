defmodule Erlef do
  @moduledoc false

  def is_env?(env), do: Application.get_env(:erlef, :env) == env
end
