defmodule ErlefWeb.PageController do
  use ErlefWeb, :controller

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params), do: render(conn)

  def board_members(conn, _params) do
    members = Enum.shuffle(Erlef.Rosters.get("board"))
    render(conn, members: members)
  end

  def bylaws(conn, _params), do: render(conn)

  def sponsor_info(conn, _params), do: render(conn, "become_a_sponsor.html")

  def contact(conn, _params), do: render(conn)

  def faq(conn, _params), do: render(conn)

  def sponsors(conn, _params) do
    %{true: founding_sponsors, false: sponsors} = Erlef.Rosters.get("sponsors") |> Enum.group_by(fn({k, x}) -> x.founding_sponsor == true end)
    render(conn, founding_sponsors: founding_sponsors, sponsors: sponsors )
  end

  def wg_proposal_template(conn, _params), do: render(conn, "wg-proposal-template.html")

  def academic_papers(conn, _params) do
    render(conn, academic_papers: Erlef.AcademicPapers.all())
  end
end
