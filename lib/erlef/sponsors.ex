defmodule Erlef.Sponsors do
  @roster Application.get_env(:erlef, :sponsors)

  def roster do
    @roster
  end
end
