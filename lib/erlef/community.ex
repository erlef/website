defmodule Erlef.Community do
  @moduledoc """
  Context module for erlef community data.
  """

  alias Ecto.{Changeset, UUID}
  alias Erlef.Community.Query
  alias Erlef.Community.Event
  alias Erlef.{Accounts, Admins, Members, Repo}
  alias Erlef.Accounts.Member
  alias Erlef.Community.{Affiliates, Resources}

  defdelegate approved_events(), to: Query
  defdelegate event_types(), to: Event, as: :types
  defdelegate get_event(id), to: Query
  defdelegate unapproved_events(), to: Query
  defdelegate unapproved_events_count(), to: Query

  @doc """
  Returns a map of community resources, such as lists of languages, tools, etc. 
  Said map does not include database backed entities such as events.
  """

  defdelegate all_resources(), to: Resources, as: :all
  defdelegate all_affiliates(), to: Affiliates, as: :all

  @spec approve_event(UUID.t(), map()) :: {:ok, Event.t()} | {:error, Changeset.t()}
  def approve_event(id, params) do
    Repo.transaction(fn ->
      with %Event{} = event <- Query.get_event(id),
           %Member{} = member <- Accounts.get_member(event.submitted_by_id),
           %Ecto.Changeset{} = cs <- Event.approval_changeset(event, params),
           {:ok, event} <- Repo.update(cs),
           {:ok, _notify} <- Members.notify(:new_event_approved, %{member: member}) do
        event
      else
        {:error, err} ->
          Repo.rollback(err)

        err ->
          Repo.rollback(err)
      end
    end)
  end

  def change_event(event), do: Erlef.Community.Event.new_changeset(event)

  @spec format_error(any()) :: String.t()
  def format_error({:error, :unsupported_org_file_type}) do
    "The event organization logo you attempted to upload is not supported." <>
      " " <>
      "Supported formats : jpg, png"
  end

  def format_error(_) do
    "An unknown error occurred"
  end

  @spec new_event() :: Changeset.t()
  def new_event, do: Event.new_changeset(%Event{}, %{})

  @spec new_event(map()) :: Changeset.t()
  def new_event(params), do: Event.new_changeset(%Event{}, params)

  @spec submit_event(params :: map(), opts :: map()) :: {:ok, Event.t()} | {:error, term()}
  def submit_event(params, opts) do
    Repo.transaction(fn ->
      with {:ok, event_params} <- maybe_upload_org_image(params),
           %Changeset{} = cs <- Event.new_submission(event_params),
           {:ok, cs} <- valid_changeset(cs),
           {:ok, event} <- Repo.insert(cs),
           {:ok, _notify} <- Admins.notify(:new_event_submitted, opts),
           {:ok, _notify} <- Members.notify(:new_event_submitted, opts) do
        event
      else
        {:error, err} ->
          Repo.rollback(err)

        err ->
          Repo.rollback(err)
      end
    end)
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
