defmodule Erlef.Events.Repo do
  @priv :code.priv_dir(:erlef)
  @root "priv/events"
  use Nabo.Repo, root: @root

  def root, do: @root
end
