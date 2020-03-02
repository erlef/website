defmodule ErlefWeb.AcademicPapersLive do
  @moduledoc """
  Live view for academic papers. Handles the filtering event
  """
  use Phoenix.LiveView

  alias Erlef.Data.Query.AcademicPaper, as: Query

  def mount(_params, %{"academic_papers" => academic_papers}, socket),
    do: {:ok, assign(socket, :academic_papers, academic_papers)}

  def render(assigns) do
    ErlefWeb.AcademicPaperView.render("_papers.html", assigns)
  end

  def handle_event("filter", %{"filter" => "ALL"}, socket) do
    {:noreply, assign(socket, :academic_papers, Query.published())}
  end

  def handle_event("filter", %{"filter" => filter}, socket) do
    academic_papers = Query.published() |> Enum.filter(&(filter in &1.technologies))
    {:noreply, assign(socket, :academic_papers, academic_papers)}
  end
end
