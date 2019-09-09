defmodule ErlefWeb.BlogController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.{Blogs, WG}

  # not sure what we want to do with this yet.
  def index(conn, %{"topic" => topic}) do
    case fetch_working_group(topic) do
      nil ->
        {:error, :not_found}

      wkgroup ->
        render(conn, "index.html", topic: topic, wg: wkgroup, posts: list(topic))
    end
  end

  def index(conn, _params) do
    index(conn, %{"topic" => "eef"})
  end

  def show(conn, %{"id" => id}) do
    case get(id) do
      {:ok, post} ->
        render(conn, "show.html", slug: id, post: post, working_group: fetch_working_group(post))

      _ ->
        {:error, :not_found}
    end
  end

  defp get(id) do
    case Blogs.Repo.get(id) do
      {:ok, post} -> {:ok, post}
      _ -> {:error, :not_found}
    end
  end

  defp fetch_working_group(%{metadata: %{"category" => slug}}) when not is_nil(slug) do
    WG.fetch(slug)
  end

  defp fetch_working_group(name) when is_bitstring(name), do: WG.fetch(name)
  defp fetch_working_group(_), do: nil

  def list("eef"), do: Blogs.Repo.index()
  def list(name) when not is_nil(name), do: Blogs.Repo.for_wg(name)
  def list(_), do: []
end
