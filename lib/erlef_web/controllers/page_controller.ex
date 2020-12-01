defmodule ErlefWeb.PageController do
  use ErlefWeb, :controller

  alias Erlef.{
    Blogs,
    Groups,
    Twitter,
    Query.Event
  }

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    latest_news = Blogs.latest_posts()

    render(conn,
      working_groups: Groups.all_working_groups(),
      latest_news: latest_news,
      tweets: Twitter.latest_tweets(),
      events: Event.approved() |> Enum.take(3)
    )
  end

  def board_members(conn, _params) do
    members = Enum.shuffle(Erlef.Rosters.get("board"))
    render(conn, members: members)
  end

  def bylaws(conn, _params), do: render(conn)

  def community(conn, _params) do
    render(conn, community: Erlef.Community.all())
  end

  def sponsor_info(conn, _params), do: render(conn, "become_a_sponsor.html")

  def contact(conn, _params), do: render(conn)

  def faq(conn, _params), do: render(conn)

  def sponsors(conn, _params) do
    %{true: founding_sponsors, false: sponsors} =
      Erlef.Rosters.get("sponsors") |> Enum.group_by(fn {_k, x} -> x.founding_sponsor == true end)

    render(conn, founding_sponsors: founding_sponsors, sponsors: sponsors)
  end

  def wg_proposal_template(conn, _params), do: render(conn, "wg-proposal-template.html")
end
