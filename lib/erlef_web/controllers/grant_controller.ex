defmodule ErlefWeb.GrantController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, errors: [], params: %{})
  end

  def create(%{private: %{phoenix_format: "html"}} = conn, params) do
    files = params["files"] || []

    case Erlef.GrantProposal.from_map(Map.put(params, "files", files)) do
      {:ok, proposal} ->
        Erlef.GrantMail.submission(proposal) |> Erlef.Mailer.send()
        Erlef.GrantMail.submission_copy(proposal) |> Erlef.Mailer.send()
        render(conn)

      {:error, errs} ->
        render(conn, "index.html", params: params, errors: errs)
    end
  end
end
