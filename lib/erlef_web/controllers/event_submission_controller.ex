defmodule ErlefWeb.EventSubmissionController do
  use ErlefWeb, :controller
  alias Erlef.Community

  action_fallback ErlefWeb.FallbackController

  def create(conn, %{"event" => params}) do
    user = conn.assigns.current_user

    p = Map.put(params, "submitted_by_id", user.id)

    case Community.submit_event(p, %{member: user}) do
      {:ok, _event} ->
        conn
        |> put_flash(
          :success,
          "<h3 class='text-center'>Thanks! 😁 Your event will be reviewed by an admin shortly...</h3>"
        )
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        changes = %{changeset.changes | description: params["description"]}

        render(conn, "new.html",
          error: nil,
          changeset: %{changeset | changes: changes, action: :insert},
          event_types: Community.event_types()
        )

      err ->
        err_str = Community.format_error(err)
        cs = Community.new_event(params)
        types = Community.event_types()
        render(conn, "new.html", changeset: cs, event_types: types, error: err_str)
    end
  end

  def new(conn, _params) do
    render(conn,
      error: nil,
      changeset: Community.new_event(),
      event_types: Community.event_types()
    )
  end
end
