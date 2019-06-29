defmodule ErlefWeb.PageController do
  use ErlefWeb, :controller

  def index(conn, _params), do: render(conn, "index.html")

  def about(conn, _params), do: render(conn, "about.html")

  def building(conn, _params), do: render(conn, "building.html")

  def bylaws(conn, _params), do: render(conn, "bylaws.html")

  def contact(conn, _params), do: render(conn, "contact.html")

  def faq(conn, _params), do: render(conn, "faq.html")

  def fellowship(conn, _params), do: render(conn, "fellowship.html")

  def marketing(conn, _params), do: render(conn, "marketing.html")

  def observability(conn, _params), do: render(conn, "observability.html")

  def proposal(conn, _params), do: render(conn, "propsal.html")

  def sponsors(conn, _params) do 
    sponsors = Erlef.Sponsors.roster()
    render(conn, "sponsors.html", sponsors: sponsors)
  end

  def sponsorship(conn, _params), do: render(conn, "sponsorship.html")

  def working_groups(conn, _params), do: render(conn, "wg.html")
end
