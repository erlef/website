defmodule Erlef.Blogs.Marketing do
  @root "priv/posts/marketing"
  def root, do: @root

  use Nabo.Repo, root: @root
end
