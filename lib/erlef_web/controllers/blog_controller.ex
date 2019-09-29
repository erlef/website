defmodule ErlefWeb.BlogController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.{Blog, Posts, WorkingGroup}

  def index(conn, %{"topic" => topic}) do
    case fetch_working_group(topic) do
      nil ->
        {:error, :not_found}

      wg ->
        render(conn, "index.html",
          topic: topic,
          name: wg.name,
          description: wg.description,
          posts: list(topic)
        )
    end
  end

  def index(conn, _params) do
    descrip = "Find all the related news of the Erlang Ecosystem Foundation"

    render(conn, "index.html", topic: "eef", name: "EEF", description: descrip, posts: list("eef"))
  end

  def show(conn, %{"id" => id}) do
    case get(id) do
      {:ok, post} ->
        render(conn, "show.html", slug: id, post: post, working_group: fetch_working_group(post))

      _ ->
        {:error, :not_found}
    end
  end

  defp get(id), do: Posts.get_by_slug(Blog, id)

  defp fetch_working_group(%{metadata: %{"category" => slug}}) when not is_nil(slug) do
    Posts.get_by_slug(WorkingGroup, slug)
  end

  defp fetch_working_group(name) when is_bitstring(name),
    do: Posts.get_by_slug(WorkingGroup, name)

  defp fetch_working_group(_), do: nil

  def list("eef"), do: Posts.all(Blog)
  def list(name) when not is_nil(name), do: Posts.get_by_category(Blog, name)
  def list(_), do: []
end
