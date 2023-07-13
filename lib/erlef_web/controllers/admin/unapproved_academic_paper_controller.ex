defmodule ErlefWeb.Admin.UnapprovedAcademicPaperController do
  use ErlefWeb, :controller

  alias Erlef.AcademicPapers

  action_fallback ErlefWeb.FallbackController

  def index(conn , _params) do
    unapproved_academic_papers = AcademicPapers.unapproved_all()
    render(conn , unapproved_academic_papers: unapproved_academic_papers)
  end

  def edit(conn , %{"id" => id}) do
    unapproved_academic_paper = AcademicPapers.get(id)
    changeset = AcademicPapers.change_academic_paper(unapproved_academic_paper)
    render(conn , :edit , unapproved_academic_paper: unapproved_academic_paper , changeset: changeset)
  end

  def approve(conn , %{"id" =>id , "academic_paper" => params}) do
    unapproved_academic_paper = AcademicPapers.get(id)
    unapproved_academic_paper
    |> AcademicPapers.approve_academic_paper(params)
    |> case do
    	  {:ok , _approved_academic_paper} ->
		conn
		|> put_flash(:info , "Academic Paper has been approved successfully")
 		|> redirect(to: Routes.admin_unapproved_academic_paper_path(conn , :index))
	  {:error , %Ecto.Changeset{} = changeset} ->
  		conn
		|> render("edit.html" , unapproved_academic_paper: unapproved_academic_paper , changeset: changeset)
       end
  end

  def delete(conn , %{"id" => id}) do
    unapproved_academic_paper = AcademicPapers.get(id)
    {:ok , _unapproved_academic_paper} = AcademicPapers.delete_academic_paper(unapproved_academic_paper)
    conn
    |> put_flash(:info , "Academic Paper deleted successfully")
    |> redirect(to: Routes.admin_unapproved_academic_paper_path(conn , :index))
  end    
end
  
