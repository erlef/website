defmodule Erlef.Events.Repo do
  @root "priv/events"
  use Nabo.Repo, root: @root

  def root, do: @root
end
