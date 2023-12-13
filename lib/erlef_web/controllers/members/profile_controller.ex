defmodule ErlefWeb.Members.ProfileController do
  use ErlefWeb, :controller

  alias Erlef.Members
  alias Erlef.Jobs

  def show(conn, _) do
    current_user = conn.assigns.current_user
    conference_perks = Application.get_env(:erlef, :conference_perks)
    has_email_request = Members.has_email_request?(current_user)
    email_request = Members.get_email_request_by_member(current_user)
    posts = Jobs.list_posts_by_author_id(current_user.id)

    render(conn,
      has_email_request: has_email_request,
      email_request: email_request,
      conference_perks: conference_perks,
      video_perks_on: true,
      conference_perks_on: false,
      posts: posts
    )
  end
end
