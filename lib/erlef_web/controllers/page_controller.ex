defmodule ErlefWeb.PageController do
  use ErlefWeb, :controller

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params), do: render(conn)

  def bylaws(conn, _params), do: render(conn)

  def sponsor_info(conn, _params), do: render(conn, "become_a_sponsor.html")

  def contact(conn, _params), do: render(conn)

  def faq(conn, _params), do: render(conn)

  def sponsors(conn, _params) do
    sponsors = Enum.shuffle(Erlef.Sponsors.roster())
    render(conn, sponsors: sponsors)
  end

  def wg_proposal_template(conn, _params), do: render(conn, "wg-proposal-template.html")
end
