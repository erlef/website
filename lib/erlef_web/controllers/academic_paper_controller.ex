defmodule ErlefWeb.AcademicPaperController do
  use ErlefWeb, :controller

  alias Erlef.Publications

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, academic_papers: Publications.all())
  end
end
