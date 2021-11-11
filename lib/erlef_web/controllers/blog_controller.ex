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

      {:error, :not_allowed_to_post} ->
        {:error, :not_found}
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, post} <- Blog.get_post_by_slug(id),
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
      {:error, :not_found} ->
        {:error, :not_found}

      false ->
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
        changeset =
          %Post{authors: [conn.assigns.current_user.name]}
          |> Blog.change_post()

        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"post" => post_params}) do
    post_params =
      post_params
      |> parse_authors()
      |> parse_tags()
      |> assign_owner(conn)

    with :ok <- allowed_to_edit(conn, post_params["category"]),
         {:ok, post} <- Blog.create_post(post_params) do
      conn
      |> put_flash(:info, "Post created successfully.")
      |> redirect(to: Routes.blog_path(conn, :show, post.category, post.slug))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)

      {:error, :not_authorized_to_edit} ->
        {:error, :not_found}
    end
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, post} <- Blog.get_post_by_slug(id),
         :ok <- allowed_to_edit(conn, post.category) do
      changeset = Blog.change_post(post)
      render(conn, "edit.html", post: post, changeset: changeset)
    else
      {:error, :not_found} ->
        {:error, :not_found}

      {:error, :not_authorized_to_edit} ->
        {:error, :not_found}
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post_params =
      post_params
      |> parse_authors()
      |> parse_tags()
      |> assign_owner(conn)
      |> Map.put("updated_by", conn.assigns.current_user.id)

    with {:ok, post} <- Blog.get_post_by_slug(id),
         :ok <- allowed_to_edit(conn, post.category),
         {:ok, post} <- Blog.update_post(post, post_params) do
      conn
      |> put_flash(:info, "Post updated successfully.")
      |> redirect(to: Routes.blog_path(conn, :show, post.category, post.slug))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, post} = Blog.get_post_by_slug(id)
        render(conn, "edit.html", post: post, changeset: changeset)

      {:error, :not_found} ->
        {:error, :not_found}

      {:error, :not_authorized_to_edit} ->
        {:error, :not_found}
    end
  end

  def publish(conn, %{"id" => id}) do
    params =
      %{"status" => :published, "updated_by" => conn.assigns.current_user.id}
      |> assign_owner(conn)

    with {:ok, post} <- Blog.get_post_by_slug(id),
         :ok <- allowed_to_edit(conn, post.category),
         {:ok, post} <- Blog.update_post(post, params) do
      conn
      |> put_flash(:info, "Post published successfully.")
      |> redirect(to: Routes.blog_path(conn, :show, post.category, post.slug))
    else
      {:error, :not_found} ->
        {:error, :not_found}

      {:error, :not_authorized_to_edit} ->
        {:error, :not_found}

      # Posible error from update_post/2 should not happen but dialyzer wants it covered
      {:error, %Ecto.Changeset{}} ->
        {:error, :not_found}
    end
  end

  def archive(conn, %{"id" => id}) do
    params =
      %{"status" => :archived, "updated_by" => conn.assigns.current_user.id}
      |> assign_owner(conn)

    with {:ok, post} <- Blog.get_post_by_slug(id),
         :ok <- allowed_to_edit(conn, post.category),
         {:ok, post} <- Blog.update_post(post, params) do
      conn
      |> put_flash(:info, "Post archived successfully.")
      |> redirect(to: Routes.blog_path(conn, :show, post.category, post.slug))
    else
      {:error, :not_found} ->
        {:error, :not_found}

      {:error, :not_authorized_to_edit} ->
        {:error, :not_found}

      # Posible error from update_post/2 should not happen but dialyzer wants it covered
      {:error, %Ecto.Changeset{}} ->
        {:error, :not_found}
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, post} <- Blog.get_post_by_slug(id),
         :ok <- allowed_to_edit(conn, post.category),
         :draft <- post.status do
      {:ok, _post} = Blog.delete_post(post)

      conn
      |> put_flash(:info, "Post draft deleted successfully.")
      |> redirect(to: Routes.blog_path(conn, :index_archived))
    else
      {:error, :not_found} ->
        {:error, :not_found}

      {:error, :not_authorized_to_edit} ->
        {:error, :not_found}

      :published ->
        {:error, :not_found}

      :archived ->
        {:error, :not_found}
    end
  end

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

  defp parse_tags(%{"tags" => ""} = params), do: %{params | "tags" => []}

  defp parse_tags(%{"tags" => tags} = params) when is_bitstring(tags) do
    parsed_tags =
      tags
      |> Jason.decode!()
      |> Enum.map(&Map.fetch!(&1, "value"))

    %{params | "tags" => parsed_tags}
  end

  defp parse_tags(post_params), do: post_params

  defp parse_authors(%{"authors" => ""} = params), do: %{params | "authors" => []}

  defp parse_authors(%{"authors" => authors} = params) when is_bitstring(authors) do
    parsed_authors =
      authors
      |> Jason.decode!()
      |> Enum.map(&Map.fetch!(&1, "value"))

    %{params | "authors" => parsed_authors}
  end

  defp parse_authors(post_params), do: post_params

  defp categories(conn) do
    Blog.categories_allowed_to_post(conn.assigns.current_user)
  end

  defp allowed_to_edit(conn, category) do
    if category in categories(conn) do
      :ok
    else
      {:error, :not_authorized_to_edit}
    end
  end

  defp allowed_to_view?(conn, post) do
    post.status == :published ||
      (!!conn.assigns[:current_user] &&
         post.category in categories(conn))
  end
end
