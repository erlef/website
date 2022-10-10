defmodule ErlefWeb.Admin.JobController do
  use ErlefWeb, :controller

  action_fallback ErlefWeb.FallbackController

  alias Erlef.Jobs

  def index(conn, _params) do
    posts = Jobs.list_unapproved_posts()

    render(conn, unapproved_job_posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Jobs.get_post!(id)

    render(conn, changeset: Jobs.change_post(post), post: post)
  end

  def approve(conn, %{"id" => id}) do
    admin = conn.assigns.current_user
    post = Jobs.get_post!(id)

    case Jobs.approve_post(admin, post) do
      {:ok, _} ->
        conn
        |> redirect(to: Routes.admin_job_path(conn, :index))
        |> halt()
    end
  end
end
