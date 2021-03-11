defmodule ErlefWeb.Members.ProfileController do
  use ErlefWeb, :controller

  alias Erlef.Members

  def show(conn, _) do
    conference_perks = Application.get_env(:erlef, :conference_perks)
    has_email_request = Members.has_email_request?(conn.assigns.current_user)
    email_request = Members.get_email_request_by_member(conn.assigns.current_user)

    render(conn,
      has_email_request: has_email_request,
      email_request: email_request,
      conference_perks: conference_perks,
      video_perks_on: true
    )
  end
end
