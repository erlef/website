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

  @base_project_directory  File.cwd!()
  @base_map_directory  "/lib/erlef_web/templates/page/"

  def create_filesystem_structure(starting_directory) do
    directory_list = File.ls!(starting_directory)
    Enum.map(
      directory_list,
      fn element ->
        {element, File.dir?("#{starting_directory}/#{element}")}
      end
    )
  end

  def create_map([], _path, state), do: state
  def create_map([{element, dir?} | _t], path, state) when dir? == true do
    new_dir_structure = 
      @base_project_directory <> @base_map_directory <> element
      |> create_filesystem_structure()
    sub_dir = path <> element <> "/"
    create_map(new_dir_structure, sub_dir, state)
  end
  def create_map([{element, _dir?} | t], path, state) do
    path_element = String.trim(element, ".html.eex")
    html_file = String.trim(element, ".eex")
    state = Map.merge(state, %{"#{path}#{path_element}" => html_file})
    create_map(t, path, state)
  end

  def static_map() do
    starting_directory = create_filesystem_structure(@base_project_directory <> @base_map_directory)
    create_map(starting_directory, "/", %{})
  end

  def static_pages, do: static_map()

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
