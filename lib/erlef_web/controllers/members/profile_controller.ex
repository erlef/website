defmodule ErlefWeb.Members.ProfileController do
  use ErlefWeb, :controller

  def show(conn, _) do
    conference_perks = Application.get_env(:erlef, :conference_perks)

    render(conn,
      conference_perks: conference_perks,
      video_perks_on: true,
      conference_perks_on: false
    )
  end
end
