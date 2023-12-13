defmodule ErlefWeb.StipendController do
  use ErlefWeb, :controller

  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, errors: [], params: %{})
  end

  def faq(conn, _params) do
    render(conn, errors: [], params: %{})
  end

  def form(conn, %{"type" => type}) do
    render(conn, errors: [], params: %{}, type: type)
  end

  def form(conn, _params) do
    render(conn, errors: [], params: %{}, type: "default")
  end

  def create(%{private: %{phoenix_format: "html"}} = conn, params) do
    files = params["files"] || []

    case Erlef.StipendProposal.from_map(Map.put(params, "files", files)) do
      {:ok, proposal} ->
        proposal
        |> Erlef.StipendMail.submission()
        |> Erlef.Mailer.deliver()

        proposal
        |> Erlef.StipendMail.submission_copy()
        |> Erlef.Mailer.deliver()

        render(conn)

      {:error, errs} ->
        render(conn, "form.html", type: params["type"], params: params, errors: errs)
    end
  end
end
