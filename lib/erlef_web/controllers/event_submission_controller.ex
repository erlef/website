defmodule ErlefWeb.EventSubmissionController do
  use ErlefWeb, :controller
  action_fallback ErlefWeb.FallbackController

  def create(conn, %{"event" => params}) do
    case Erlef.Members.submit_event(maybe_upload_org_image(params)) do
      {:ok, _event} ->
        conn
        |> put_flash(
          :success,
          "<h3 class='text-center'>Thanks! 😁 Your event will be reviewed by an admin shortly...</h3>"
        )
        |> redirect(to: "/")

      {:error, changeset} ->
        changes = %{changeset.changes | description: params["description"]}

        render(conn, "new.html",
          changeset: %{changeset | changes: changes, action: :insert},
          event_types: event_types()
        )
    end
  end

  def new(conn, _params) do
    render(conn, changeset: Erlef.Members.new_event(), event_types: event_types())
  end

  defp maybe_upload_org_image(params) do
    case params["organizer_brand_logo"] do
      %Plug.Upload{} = upload ->
        organizer_brand_logo = File.read!(upload.path)
        uuid = Ecto.UUID.generate()
        ext = Path.extname(upload.filename)
        bucket_file_name = "#{uuid}#{ext}"
        mime = MIME.from_path(bucket_file_name)

        {:ok, url} =
          Erlef.Storage.upload_event_org_image(bucket_file_name, organizer_brand_logo,
            content_type: mime
          )

        Map.put(params, "organizer_brand_logo", url)

      _ ->
        params
    end
  end

  defp event_types do
    Erlef.Data.Schema.EventType
    |> Erlef.Data.Repo.all()
    |> Enum.map(fn x -> [key: x.name, value: x.id] end)
  end
end
