defmodule Erlef.Config do
  @moduledoc """
  Erlef.Config
  """

  def env, do: Application.get_env(:erlef, :env)
end
