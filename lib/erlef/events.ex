defmodule Erlef.Events do
  @moduledoc false

  alias Ecto.{Changeset, UUID}
  alias Erlef.Data.Query.Event, as: Query
  alias Erlef.Data.Schema.{Event, EventType}
  alias Erlef.Data.Repo

  @spec approve(UUID.t(), map()) :: {:ok, Event.t()} | {:error, Changeset.t()}
  def approve(id, params) do
    event = Query.get(id)

    event
    |> Event.approval_changeset(params)
    |> Repo.update()
  end

  @spec event_types() :: [Keyword.t()]
  def event_types do
    EventType
    |> Erlef.Data.Repo.all()
    |> Enum.map(fn x -> [key: x.name, value: x.id] end)
  end

  @spec format_error(any()) :: String.t()
  def format_error({:error, :unsupported_org_file_type}) do
    "The event organization logo you attempted to upload is not supported." <>
      " " <>
      "Supported formats : jpg, png"
  end

  def format_error(_) do
    "An unknown error ocurred"
  end

  @spec new_event() :: Changeset.t()
  def new_event, do: Event.new_changeset(%Event{}, %{})

  @spec new_event(map()) :: Changeset.t()
  def new_event(params), do: Event.new_changeset(%Event{}, params)

  @spec submit(params :: map()) :: {:ok, Event.t()} | {:error, Changeset.t()}
  def submit(params) do
    with {:ok, event_params} <- maybe_upload_org_image(params),
         %Changeset{} = cs <- Event.new_submission(event_params),
         {:ok, cs} <- valid_changeset(cs) do
      Repo.insert(cs)
    end
  end

  defp maybe_upload_org_image(%{"organizer_brand_logo" => %Plug.Upload{} = upload} = params) do
    with {:ok, organizer_brand_logo} <- File.read(upload.path),
         {:ok, {ext, mime}} <- org_image_type(organizer_brand_logo),
         {:ok, url} <- upload_event_org_image(organizer_brand_logo, ext, mime) do
      {:ok, Map.put(params, "organizer_brand_logo", url)}
    end
  end

  defp maybe_upload_org_image(params), do: {:ok, params}

  defp org_image_type(<<0xFF, 0xD8, _::binary>>), do: {:ok, {".jpg", "image/jpeg"}}

  defp org_image_type(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>>),
    do: {:ok, {".png", "image/png"}}

  defp org_image_type(_not_supported), do: {:error, :unsupported_org_file_type}

  defp upload_event_org_image(logo, ext, mime) do
    uuid = Ecto.UUID.generate()
    name = "#{uuid}#{ext}"
    Erlef.Storage.upload_event_org_image(name, logo, content_type: mime)
  end

  defp valid_changeset(%Changeset{valid?: true} = cs) do
    {:ok, cs}
  end

  defp valid_changeset(cs), do: {:error, cs}
end
