defmodule ErlefWeb.BlogController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Blogs

  def index(conn, %{"topic" => topic}) do
    with {:ok, posts} <- list(topic) do
      render(conn, "index.html", topic: topic, posts: posts, about: Blogs.Config.about_for(topic))
    else
      _ -> {:error, :not_found}
    end
  end

  def show(conn, %{"topic" => topic, "id" => id}) do
    with {:ok, post} <- get(topic, id) do
      render(conn, "show.html", topic: topic, post: post, about: Blogs.Config.about_for(topic))
    else
      _ -> {:error, :not_found}
    end
  end

  defp get(name, id) do
    case Blogs.Config.module_for(name) do
      nil ->
        {:error, :not_found}

      mod ->
        Blogs.get(mod, id)
    end
  end

  defp list(name) do
    case Blogs.Config.module_for(name) do
      nil ->
        {:error, :not_found}

      mod ->
        Blogs.list(mod)
    end
  end
end
