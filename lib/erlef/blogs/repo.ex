defmodule Erlef.Blogs.Repo do
  def all(repo) do
    repo.all()
  end

  def get(repo, id), do: repo.get(id)
end
