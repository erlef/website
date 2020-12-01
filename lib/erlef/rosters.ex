defmodule Erlef.Rosters do
  @moduledoc """
  Erlef.Rosters

  Interface for getting various erlef related rosters that are not working groups.
  """

  @doc """
  Gets a roster. Available rosters are `:board_members` and `:sponsors`.
  """
  def get("board") do
    Application.get_env(:erlef, :board_members)
  end

  def get("sponsors") do
    Application.get_env(:erlef, :sponsors)
  end
end
