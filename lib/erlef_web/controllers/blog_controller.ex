defmodule ErlefWeb.BlogController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  alias Erlef.Blog
  alias Erlef.Blog.Post
  alias Erlef.Groups

  def index(conn, %{"topic" => topic}) do
    case fetch_working_group(String.downcase(topic)) do
      {:error, _} = err ->
        err

      {:ok, wg} ->
        render(conn, "index.html",
          topic: topic,
          name: wg.name,
          description: wg.description,
          posts: Blog.get_posts_by_category(topic),
          latest_news: Blog.latest_posts(),
          all_tags: Blog.all_tags()
        )
    end
  end

  def index(conn, _params) do
    descrip = "Find all the related news of the Erlang Ecosystem Foundation"

    params = [
      all_tags: Blog.all_tags(),
      latest_news: Blog.latest_posts(),
      topic: "eef",
      name: "EEF",
      description: descrip,
      posts: Blog.list_blog_posts()
    ]

    render(conn, "index.html", params)
  end

  def index_archived(conn, _params) do
    case Blog.list_archived_blog_posts(conn.assigns.current_user) do
      {:ok, posts} ->
        render(conn, "index_archived.html", posts: posts)

      _ ->
        {:error, :not_found}
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, post} <- get(id),
         true <- allowed_to_view?(conn, post) do
      {:ok, wg} = maybe_fetch_working_group(post.category)

      render(conn, "show.html",
        slug: id,
        post: post,
        all_tags: Blog.all_tags(),
        working_group: wg,
        latest_news: Blog.latest_posts()
      )
    else
      _ ->
        {:error, :not_found}
    end
  end

  def tags(conn, %{"tag" => tag}) do
    render(conn, "tags.html",
      tag: tag,
      posts: Blog.get_posts_by_tag(tag),
      latest_posts: Blog.latest_posts(),
      all_tags: Blog.all_tags()
    )
  end

  def new(conn, _params) do
    case categories(conn) do
      [] ->
        {:error, :not_found}

      _ ->
        changeset = Blog.change_post(%Post{})
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"post" => post_params}) do
    post_params =
      post_params
      |> split_params(["authors", "tags"])
      |> assign_owner(conn)

    with true <- post_params["category"] in categories(conn),
         {:ok, post} <- Blog.create_post(post_params) do
      conn
      |> put_flash(:info, "Post created successfully.")
      |> redirect(to: Routes.blog_path(conn, :show, post.category, post.slug))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)

      _ ->
        {:error, :not_found}
    end
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, post} <- get(id),
         true <- post.category in categories(conn) do
      changeset = Blog.change_post(post)
      render(conn, "edit.html", post: post, changeset: changeset)
    else
      _ -> {:error, :not_found}
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = get!(id)

    post_params =
      post_params
      |> split_params(["authors", "tags"])
      |> Map.put("updated_by", conn.assigns.current_user.id)

    with true <- post.category in categories(conn),
         {:ok, post} <- Blog.update_post(post, post_params) do
      conn
      |> put_flash(:info, "Post updated successfully.")
      |> redirect(to: Routes.blog_path(conn, :show, post.category, post.slug))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)

      _ ->
        {:error, :not_found}
    end
  end

  def publish(conn, %{"id" => id}) do
    post = get!(id)
    params = %{"status" => :published, "updated_by" => conn.assigns.current_user.id}

    with true <- post.category in categories(conn),
         {:ok, post} <- Blog.update_post(post, params) do
      conn
      |> put_flash(:info, "Post published successfully.")
      |> redirect(to: Routes.blog_path(conn, :show, post.category, post.slug))
    else
      _ -> {:error, :not_found}
    end
  end

  def archive(conn, %{"id" => id}) do
    post = get!(id)
    params = %{"status" => :archived, "updated_by" => conn.assigns.current_user.id}

    with true <- post.category in categories(conn),
         {:ok, post} <- Blog.update_post(post, params) do
      conn
      |> put_flash(:info, "Post archived successfully.")
      |> redirect(to: Routes.blog_path(conn, :show, post.category, post.slug))
    else
      _ -> {:error, :not_found}
    end
  end

  def delete(conn, %{"id" => id}) do
    post = get!(id)
    case post.status do
      :draft ->
        {:ok, _post} = Blog.delete_post(post)

        conn
        |> put_flash(:info, "Post draft deleted successfully.")
        |> redirect(to: Routes.blog_path(conn, :index_archived))
      _ ->
        {:error, :not_found}
    end    
  end

  defp get!(id), do: Blog.get_post_by_slug!(id)

  defp get(id), do: Blog.get_post_by_slug(id)

  defp maybe_fetch_working_group(category)
       when category in ["eef", "newsletter"],
       do: {:ok, nil}

  defp maybe_fetch_working_group(category) do
    fetch_working_group(category)
  end

  defp fetch_working_group(%{category: slug}) when not is_nil(slug) do
    Groups.get_working_group_by_slug(slug)
  end

  defp fetch_working_group(name) when is_bitstring(name),
    do: Groups.get_working_group_by_slug(name)

  defp fetch_working_group(_), do: nil

  defp assign_owner(post_params, conn) do
    Map.put(post_params, "owner_id", conn.assigns.current_user.id)
  end

  defp split_params(post_params, params) do
    Enum.reduce(params, post_params, fn p, acc -> Map.update!(acc, p, &split_param/1) end)
  end

  defp split_param(param) when is_bitstring(param) do
    param
    |> String.split(~r/[[:blank:]]*,[[:blank:]]*/, trim: true)
    |> Enum.map(&String.trim/1)
  end

  defp split_param(param), do: param

  defp categories(conn) do
    Blog.categories_allowed_to_post(conn.assigns.current_user)
  end

  defp allowed_to_view?(conn, post) do
    post.status == :published ||
      (!!conn.assigns[:current_user] &&
         post.category in categories(conn))
  end
end
