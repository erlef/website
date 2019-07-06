defmodule Erlef.Blogs.Fellowship do
  @root "priv/posts/fellowship"
  def root, do: @root

  use Nabo.Repo, root: @root
end
