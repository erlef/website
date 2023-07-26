defmodule ErlefWeb.AcademicPaperController do
  use ErlefWeb, :controller

  alias Erlef.AcademicPapers
  alias Erlef.AcademicPapers.AcademicPaper
  alias Erlef.{Accounts, Admins, Members}

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, academic_papers: AcademicPapers.all())
  end

  def new(conn, _params) do
    changeset = AcademicPapers.change_academic_paper(%AcademicPaper{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"academic_paper" => params}) do
    submitter_id = conn.assigns.current_user.id
    new_params = Map.put(params, "submitted_by", submitter_id)

    case AcademicPapers.create_academic_paper(new_params) do
      {:ok, _academic_paper} ->
        type = :new_academic_paper_submitted
        submitter = Accounts.get_member(submitter_id)
        opts = %{member: submitter}
        {:ok, _notify} = Admins.notify(type, opts)
        {:ok, _notify} = Members.notify(type, opts)

        conn
        |> put_flash(:info, "Paper Submitted and has to be Approved")
        |> redirect(to: "/")

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
