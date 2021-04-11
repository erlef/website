defmodule ErlefWeb.Admin.EmailRequestController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController
  alias Erlef.Members

  def index(conn, _params) do
    requests = Members.outstanding_email_requests()
    render(conn, email_requests: requests)
  end

  def show(conn, %{"id" => id}) do
    req = Members.get_email_request(id)

    logs =
      Enum.map(req.logs, fn l ->
        cast_assigned_to(l, conn)
      end)

    render(conn,
      email_request: %{req | logs: logs}
    )
  end

  def assign(conn, %{"request" => id}) do
    req = Members.get_email_request(id)

    {:ok, _req} =
      Members.update_email_request(req, %{
        status: :in_progress,
        assigned_to_id: conn.assigns.current_user.id
      })

    redirect(conn, to: Routes.admin_email_request_path(conn, :show, id))
  end

  def complete(conn, %{"id" => id, "password" => password}) do
    :ok = Members.complete_email_request(%{id: id, password: password})
    redirect(conn, to: Routes.admin_email_request_path(conn, :show, id))
  end

  def complete(conn, %{"id" => id}) do
    :ok = Members.complete_email_request(%{id: id})
    redirect(conn, to: Routes.admin_email_request_path(conn, :show, id))
  end

  defp cast_assigned_to(req, conn) do
    case req.assigned_to_id do
      nil ->
        req

      id when id == conn.assigns.current_user.id ->
        %{req | assigned_to: conn.assigns.current_user}

      _not_current_user ->
        member = Erlef.Accounts.get_member!(req.assigned_to)
        %{req | assigned_to: member}
    end
  end
end
