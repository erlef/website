defmodule ErlefWeb.Admin.AcademicPaperController do
  use ErlefWeb, :controller

  alias Erlef.AcademicPapers

  action_fallback ErlefWeb.FallbackController

  def index(conn , _params) do
    academic_papers = AcademicPapers.all
    render(conn , academic_papers: academic_papers)
  end

  def show(conn , %{"id" => id}) do
    academic_paper = AcademicPapers.get(id)
    render(conn , "show.html" , academic_paper: academic_paper)
  end

  def edit(conn , %{"id" => id}) do
    academic_paper = AcademicPapers.get(id)
    changeset = AcademicPapers.change_academic_paper(academic_paper)	
    render(conn , "edit.html" , academic_paper: academic_paper , changeset: changeset)
  end

  def update(conn , %{"id" => id , "academic_paper" => params}) do
    academic_paper = AcademicPapers.get(id)
    academic_paper
    |> AcademicPapers.update_academic_paper(params)
    |> case do
       	    {:ok , academic_paper} ->
		  conn
		  |> put_flash(:info , "Academic Paper updated successfully")
		  |> redirect(to: Routes.admin_academic_paper_path(conn , :show , academic_paper))
	    {:error , %Ecto.Changeset{} = changeset} ->
		  conn
		  |> render("edit.html" , academic_paper: academic_paper , changeset: changeset)
       end
  end

  def delete(conn , %{"id" => id}) do
    academic_paper = AcademicPapers.get(id)
    {:ok , _academic_paper} = AcademicPapers.delete_academic_paper(academic_paper)
    conn
    |> put_flash(:info , "Academic Paper deleted successfully")
    |> redirect(to: Routes.admin_academic_paper_path(conn , :index))
  end
end
