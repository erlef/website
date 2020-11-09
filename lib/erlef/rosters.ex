defmodule Erlef.Rosters do
  @moduledoc """
  Erlef.Members
  """

  def get("board") do
    Application.get_env(:erlef, :board_members)
  end

  def get("sponsors") do
    Application.get_env(:erlef, :sponsors)
  end
end
