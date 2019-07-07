defmodule Erlef.Blogs.Security do
  @root "priv/posts/security"
  def root, do: @root

  use Nabo.Repo, root: @root
end
