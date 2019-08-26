defmodule ErlefWeb.GrantController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  def index(conn, _params) do
    render(conn, errors: [])
  end

  def create(%{private: %{phoenix_format: "html"}} = conn, params) do
    case Erlef.GrantProposal.from_map(params) do
      {:ok, proposal} ->
        Erlef.GrantMail.submission(proposal) |> Erlef.Mailer.send()
        Erlef.GrantMail.submission_copy(proposal) |> Erlef.Mailer.send()
        render(conn)

      {:error, errs} ->
        render(conn, "index.html", errors: errs)
    end
  end
end
