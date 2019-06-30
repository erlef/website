defmodule ErlefWeb.PageController do
  use ErlefWeb, :controller

  action_fallback ErlefWeb.FallbackController

  # TODO: Read in existing files/dirs from templates/page to create this map
  @static_map %{
    "/" => "index.html",
    "/about/" => "about.html",
    "/wg/building" => "building.html",
    "/bylaws/" => "bylaws.html",
    "/contact/" => "contact.html",
    "/faq/" => "faq.html",
    "/sponsors/" => "/sponsors",
    "/wg/fellowship" => "fellowship.html",
    "/wg/marketing" => "marketing.html",
    "/wg/observability" => "observability.html",
    "/wg/proposal" => "proposal.html",
    "/wg/sponsorship" => "sponsorship.html",
    "/wg/" => "wg.html"
  }

  def static_pages, do: @static_map

  def page(%{request_path: "/sponsors/"} = conn, _params) do
    sponsors = Erlef.Sponsors.roster()
    render(conn, "sponsors.html", sponsors: sponsors)
  end

  def page(conn, _params), do: index_for(conn)

  def index_for(%{request_path: path} = conn) do
    case Map.get(@static_map, path) do
      nil ->
        {:error, :not_found}

      template ->
        render(conn, template)
    end
  end
end
