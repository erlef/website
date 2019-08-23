defmodule Erlef.Config do
  def env, do: Application.get_env(:erlef, :env)
end
