defmodule Erlef.Blogs do
  alias Erlef.Blogs.Repo

  def list(blog) do
    {:ok, Repo.all(blog)}
  end

  def get(blog, id) do
    Repo.get(blog, id)
  end
end
