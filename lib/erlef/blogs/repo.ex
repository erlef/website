defmodule Erlef.Blogs.Repo do
  @root "priv/posts/**"

  use Nabo.Repo, root: @root

  @spec for_wg(String.t()) :: [Nabo.Post.t()]
  def for_wg(wg) do
    load_all()
    |> filter_by_category(wg)
  end

  @spec load_all(String.t()) :: [Nabo.Post.t()]
  def load_all(path \\ @root) do
    path
    |> Path.join(["*", ".md"])
    |> Path.wildcard()
    |> Enum.reduce([], &compile/2)
  end

  defp for_slug(posts, slug) do
    posts
    |> Enum.find(&(&1.slug == slug))
  end

  defp filter_by_category(posts, category) do
    posts
    |> Enum.filter(&(Map.get(&1.metadata, "category") == category))
  end

  defp compile(path, acc) do
    path
    |> File.read!()
    |> Nabo.Compiler.compile([])
    |> case do
      {:ok, _slug, post} -> [post | acc]
      _ -> acc
    end
  end
end
