defmodule ErlefWeb.EventSubmissionController do
  use ErlefWeb, :controller
  alias Erlef.Events

  action_fallback ErlefWeb.FallbackController

  def create(conn, %{"event" => params}) do
    case Events.submit(params) do
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
          event_types: Events.event_types()
        )

      err ->
        err_str = Events.format_error(err)
        cs = Events.new_event(params)
        types = Events.event_types()
        render(conn, "new.html", changeset: cs, event_types: types, error: err_str)
    end
  end

  def new(conn, _params) do
    render(conn, error: nil, changeset: Events.new_event(), event_types: Events.event_types())
  end
end
