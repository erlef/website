defmodule ErlefWeb.JobController do
  use ErlefWeb, :controller

  alias Ecto.Changeset
  alias Erlef.Jobs
  alias Erlef.Groups
  alias __MODULE__.CreatePostForm
  alias __MODULE__.UpdatePostForm

  plug :post_quota_guard when action in [:new, :create]
  plug :authorize_post when action in [:edit, :update, :delete]

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    posts = Jobs.list_posts()

    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = CreatePostForm.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  # The function is explicitly ignored by Dialyzer because if for some reason
  # `Erlef.Jobs.create_post/2` returns a changeset error, the user can't do
  # anything about it so it's better to return a status 500. If the validation
  # of the form passes, it means there's a problem in using the valid user-
  # provided data.
  @dialyzer {:nowarn_function, create: 2}
  def create(conn, %{"post" => post_params}) do
    current_user = conn.assigns.current_user

    normalization =
      %CreatePostForm{}
      |> CreatePostForm.changeset(post_params)
      |> Changeset.apply_action(:insert)

    with {:ok, form} <- normalization,
         post_params = Map.from_struct(form),
         {:ok, post} <- Jobs.create_post(current_user, post_params) do
      conn
      |> put_flash(:info, "Post created successfully.")
      |> redirect(to: Routes.job_path(conn, :show, post.id))
    else
      {:error, %Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Jobs.get_post!(id)
    current_user = conn.assigns.current_user

    if post.approved || (current_user && Jobs.owns_post?(current_user, post)) do
      %{sponsor_id: sponsor_id} = post
      sponsor = sponsor_id && Groups.get_sponsor!(sponsor_id)

      render(conn, "show.html", post: post, sponsor: sponsor)
    else
      conn
      |> put_status(404)
      |> put_view(ErlefWeb.ErrorView)
      |> render("404.html")
    end
  end

  def edit(conn, _) do
    post = conn.assigns.post
    changeset = UpdatePostForm.for_post(post)

    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"post" => post_params}) do
    %{current_user: current_user, post: post} = conn.assigns

    normalization =
      %UpdatePostForm{}
      |> UpdatePostForm.changeset(post_params)
      |> Changeset.apply_action(:update)

    with {:ok, form} <- normalization,
         post_params = Map.from_struct(form),
         {:ok, updated} <- Jobs.update_post(current_user, post, post_params) do
      conn
      |> put_flash(:info, "Post updated successfully.")
      |> redirect(to: Routes.job_path(conn, :show, updated.id))
    else
      {:error, %Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, _) do
    %{current_user: current_user, post: post} = conn.assigns
    {:ok, _} = Jobs.delete_post(current_user, post)

    conn
    |> put_flash(:info, "Post deleted successfully")
    |> redirect(to: redirection_target(conn))
  end

  defp redirection_target(conn) do
    conn.params["redirect_to"] || Routes.job_path(conn, :index)
  end

  defp post_quota_guard(conn, _) do
    current_user = conn.assigns.current_user

    if Jobs.can_create_post?(current_user) do
      conn
    else
      conn
      |> put_flash(:error, "You've reached your post quota.")
      |> redirect(to: "/")
      |> halt()
    end
  end

  defp authorize_post(conn, _) do
    post = Jobs.get_post!(conn.params["id"])
    current_user = conn.assigns.current_user

    if Jobs.owns_post?(current_user, post) do
      assign(conn, :post, post)
    else
      conn
      |> put_status(404)
      |> put_view(ErlefWeb.ErrorView)
      |> render("404.html")
    end
  end
end
