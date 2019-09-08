defmodule Erlef.Rosters do
  @moduledoc """
  Erlef.Members
  """

  @board_members Application.get_env(:erlef, :board_members)

  @sponsors Application.get_env(:erlef, :sponsors)

  def get("board") do
    @board_members
  end

  def get("sponsors") do
    @sponsors
  end
end
