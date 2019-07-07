defmodule Erlef.Blogs.Education do
  @root "priv/posts/education"

  def root, do: "priv/posts/education"

  use Nabo.Repo, root: @root
end
