defmodule ErlefWeb.AcademicPaperController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, academic_papers: Erlef.AcademicPapers.all())
  end
end
