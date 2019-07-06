defmodule Erlef.Blogs.Observability do
  @root "priv/posts/observability"
  def root, do: @root

  use Nabo.Repo, root: @root
end
