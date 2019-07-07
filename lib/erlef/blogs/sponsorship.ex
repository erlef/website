defmodule Erlef.Blogs.Sponsorship do
  @root "priv/posts/sponsorship"
  def root, do: @root

  use Nabo.Repo, root: @root
end
