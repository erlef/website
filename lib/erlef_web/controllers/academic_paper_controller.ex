defmodule ErlefWeb.AcademicPaperController do
  use ErlefWeb, :controller

  alias Erlef.Data.Query.AcademicPaper, as: Query

  action_fallback ErlefWeb.FallbackController


  def index(conn, _params) do
    render(conn, :index, academic_papers: Query.published())
  end
end
