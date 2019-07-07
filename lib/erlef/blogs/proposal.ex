defmodule Erlef.Blogs.Proposal do
  @root "priv/posts/proposal"
  def root, do: @root

  use Nabo.Repo, root: @root
end
