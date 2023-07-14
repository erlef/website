defmodule ErlefWeb.AcademicPaperController do
  use ErlefWeb, :controller

  alias Erlef.AcademicPapers
  alias Erlef.AcademicPapers.AcademicPaper

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, academic_papers: AcademicPapers.all())
  end

  def new(conn, _params) do
    changeset = AcademicPapers.change_academic_paper(%AcademicPaper{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"academic_paper" => params}) do
    case AcademicPapers.create_academic_paper(params) do
      {:ok, _academic_paper} ->
        conn
        |> put_flash(:info, "Paper Submitted and has to be Approved")
        |> redirect(to: "/")

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
