defmodule ErlefWeb.BlogController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Blogs

  # not sure what we want to do with this yet.
  def index(conn, %{"topic" => topic}) do
    with {:ok, posts} <- list(topic) do
      render(conn, "index.html", topic: topic, wg: Erlef.WG.fetch(topic), posts: posts)
    else
      _ -> 
      render(conn, "index.html", topic: topic, wg: Erlef.WG.fetch(topic), posts: [])
    end
  end

  def index(conn, _params) do
    index(conn, %{"topic" => "eef"})
  end

  def show(conn, %{"id" => id}) do
    with {:ok, post} <- get(id) do
      render(conn, "show.html", slug: id, post: post, working_group: fetch_working_group(post))
    else
      _ -> {:error, :not_found}
    end
  end

  defp get(id) do
    case Blogs.Repo.get(id) do
      {:ok, post} -> {:ok, post}
      _ -> {:error, :not_found}
    end
  end

  defp fetch_working_group(%{metadata: %{"category" => slug}}) when not is_nil(slug) do
    Erlef.WG.fetch(slug)
  end

  defp fetch_working_group(_), do: nil

  defp list(name) do
    {:ok, Erlef.Blogs.Repo.for_wg(name)}
  end
end
