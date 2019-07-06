defmodule Erlef.Blogs.Building do
  @root "priv/posts/building"
  def root, do: @root

  use Nabo.Repo, root: @root
end
