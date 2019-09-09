defmodule Erlef.Sponsors do
  @moduledoc """
  Erlef.Sponsors
  """

  @roster Application.get_env(:erlef, :sponsors)

  def roster do
    @roster
  end
end
