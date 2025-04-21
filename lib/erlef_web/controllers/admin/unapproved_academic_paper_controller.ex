defmodule ErlefWeb.Admin.UnapprovedAcademicPaperController do
  use ErlefWeb, :controller

  alias Erlef.AcademicPapers
  alias Erlef.{Accounts, Members}

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    unapproved_academic_papers = AcademicPapers.unapproved_all()
    render(conn, unapproved_academic_papers: unapproved_academic_papers)
  end

  def edit(conn, %{"id" => id}) do
    unapproved_academic_paper = AcademicPapers.get(id)
    changeset = AcademicPapers.change_academic_paper(unapproved_academic_paper)

    render(conn, :edit,
      unapproved_academic_paper: unapproved_academic_paper,
      changeset: changeset
    )
  end

  def approve(conn, %{"id" => id, "academic_paper" => params}) do
    unapproved_academic_paper = AcademicPapers.get(id)
    approver_id = conn.assigns.current_user.id
    new_params = Map.put(params, "approved_by", approver_id)

    unapproved_academic_paper
    |> AcademicPapers.approve_academic_paper(new_params)
    |> case do
      {:ok, approved_academic_paper} ->
        submitter_id = approved_academic_paper.submitted_by

        case submitter_id do
          nil ->
            :ok

          _ ->
            type = :new_academic_paper_approved
            submitter = Accounts.get_member(submitter_id)
            opts = %{member: submitter}
            {:ok, _notify} = Members.notify(type, opts)
        end

        conn
        |> put_flash(:info, "Academic Paper has been approved successfully")
        |> redirect(to: Routes.admin_unapproved_academic_paper_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("edit.html",
          unapproved_academic_paper: unapproved_academic_paper,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    unapproved_academic_paper = AcademicPapers.get(id)

    {:ok, _unapproved_academic_paper} =
      AcademicPapers.delete_academic_paper(unapproved_academic_paper)

    conn
    |> put_flash(:info, "Academic Paper deleted successfully")
    |> redirect(to: Routes.admin_unapproved_academic_paper_path(conn, :index))
  end
end
