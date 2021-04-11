defmodule ErlefWeb.Members.EmailRequestController do
  use ErlefWeb, :controller

  alias Erlef.Members

  def new(conn, _) do
    case Members.has_email_request?(conn.assigns.current_user) do
      false ->
        render(conn, error: nil, changeset: Members.new_email_request())

      true ->
        conn
        |> put_flash(:info, "You already have an outstanding email request")
        |> redirect(to: Routes.members_profile_path(conn, :show))
    end
  end

  def create(conn, %{"email_request" => params}) do
    req_params = %{
      "status" => "created",
      "submitted_by_id" => conn.assigns.current_user.id
    }

    case Members.create_email_request(Map.merge(params, req_params)) do
      {:ok, _req} ->
        conn
        |> put_flash(:success, "Email request successfully created")
        |> redirect(to: Routes.members_profile_path(conn, :show))

      err ->
        err
    end
  end

  def show(conn, _) do
    render(conn)
  end
end
