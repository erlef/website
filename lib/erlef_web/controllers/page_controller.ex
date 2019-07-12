defmodule ErlefWeb.PageController do
  use ErlefWeb, :controller

  action_fallback ErlefWeb.FallbackController

  # TODO: Read in existing files/dirs from templates/page to create this map
  @static_map %{
    "/wg/building" => "building.html",
    "/wg/education" => "education.html",
    "/wg/fellowship" => "fellowship.html",
    "/wg/marketing" => "marketing.html",
    "/wg/observability" => "observability.html",
    "/wg/proposal" => "proposal.html",
    "/wg/sponsorship" => "sponsorship.html",
    "/wg/" => "wg.html"
  }

  def index(conn, _params) do
    render(conn)
  end

  def about(conn, _params) do
    render(conn)
  end

  def bylaws(conn, _params) do
    render(conn)
  end

  def contact(conn, _params) do
    render(conn)
  end

  def faq(conn, _params) do
    render(conn)
  end

  def sponsors(conn, _params) do
    sponsors = Erlef.Sponsors.roster()
    render(conn, sponsors: sponsors)
  end

  def static_pages, do: @static_map

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
