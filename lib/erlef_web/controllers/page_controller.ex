defmodule ErlefWeb.PageController do
  use ErlefWeb, :controller

  alias Erlef.{
    Community,
    Blog,
    Groups,
    Twitter
  }

  action_fallback ErlefWeb.FallbackController

  def all_calendars(conn, _params) do
    {:ok, combined} = Erlef.Agenda.get_combined()

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, combined)
  end

  def index(conn, _params) do
    latest_news = Blog.latest_posts()

    render(conn,
      working_groups: Groups.list_working_groups(),
      latest_news: latest_news,
      tweets: Twitter.latest_tweets(),
      events: Community.approved_events() |> Enum.take(3)
    )
  end

  def board_members(conn, _params) do
    members = Enum.shuffle(Groups.list_board_members())
    render(conn, members: members)
  end

  def bylaws(conn, _params), do: render(conn)

  def affiliates(conn, _params) do
    render(conn, affiliates: Erlef.Community.all_affiliates())
  end

  def community(conn, _params) do
    render(conn, community: Erlef.Community.all_resources())
  end

  def sponsor_info(conn, _params), do: render(conn, "become_a_sponsor.html")

  def contact(conn, _params), do: render(conn)

  def faq(conn, _params), do: render(conn)

  def fellows(conn, _params) do
    render(conn, fellows: Erlef.Fellows.all())
  end

  def public_records(conn, _), do: render(conn)

  def sponsors(conn, _params) do
    render(conn)
  end

  def past_founding_sponsors(conn, _params) do
    render(conn)
  end

  def wg_proposal_template(conn, _params), do: render(conn, "wg-proposal-template.html")
end
