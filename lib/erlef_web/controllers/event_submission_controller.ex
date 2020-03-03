defmodule ErlefWeb.EventSubmissionController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  def create(conn, %{"event" => params}) do
    organizer_brand_logo = File.read!(params["organizer_brand_logo"].path)

    case Erlef.Members.submit_event(Map.put(params, "organizer_brand_logo", organizer_brand_logo)) do
      {:ok, _event} ->
        conn
        |> put_flash(
          :success,
          "<h3>Thanks! 😁 Your event will be reviewed by an admin shortly...</h3>"
        )
        |> redirect(to: "/")

      {:error, changeset} ->
        render(conn, "index.html", changeset: %{changeset | action: :insert})
    end
  end

  def index(conn, _params) do
    render(conn, changeset: Erlef.Members.new_event())
  end

  def show(conn, _params) do
    render(conn)
  end
end
