defmodule Erlef.Groups do
  @moduledoc """
  Erlef.Groups context
  """

  alias Erlef.{Repo, Storage}
  alias Erlef.Accounts.Member

  alias Erlef.Groups.{
    Volunteer,
    WorkingGroup,
    WorkingGroupChair,
    WorkingGroupVolunteer,
    Query,
    Sponsor
  }

  def is_chair?(wg, %Volunteer{member_id: member_id}) do
    is_chair?(wg, member_id)
  end

  def is_chair?(wg, %Member{id: member_id}) do
    is_chair?(wg, member_id)
  end

  def is_chair?(%WorkingGroup{chairs: chairs}, member_id) when is_binary(member_id) do
    Enum.any?(chairs, fn c -> c.member_id == member_id end)
  end

  def is_chair?(_wg, _member_or_id), do: false

  @spec list_volunteers() :: [Volunteer.t()]
  def list_volunteers(), do: Repo.all(Volunteer)

  @spec get_volunteer(Ecto.UUID.t()) :: WorkingGroup.t()
  def get_volunteer(id), do: Repo.get(Volunteer, id)

  @spec create_volunteer(map()) :: {:ok, Volunteer.t()} | {:error, Ecto.Changeset.t()}
  def create_volunteer(attrs) do
    %Volunteer{}
    |> Volunteer.changeset(attrs)
    |> Repo.insert()
  end

  @spec change_volunteer(Volunteer.t(), map()) :: Ecto.Changeset.t()
  def change_volunteer(%Volunteer{} = v, attrs \\ %{}) do
    Volunteer.changeset(v, attrs)
  end

  @spec update_volunteer(Volunteer.t(), map()) ::
          {:ok, Volunteer.t()} | {:error, Ecto.Changeset.t()}
  def update_volunteer(%Volunteer{} = v, attrs) do
    v
    |> Volunteer.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_volunteer(Volunteer.t()) :: {:ok, Volunteer.t()} | {:error, Ecto.Changeset.t()}
  def delete_volunteer(%Volunteer{} = v) do
    Repo.delete(v)
  end

  @spec list_working_groups() :: [WorkingGroup.t()]
  def list_working_groups(), do: Repo.all(Query.all_working_groups())

  @spec get_working_group(Ecto.UUID.t()) :: WorkingGroup.t() | nil
  def get_working_group(id), do: Repo.get(WorkingGroup, id)

  @spec get_working_group_by_slug(String.t()) :: {:ok, WorkingGroup.t()} | {:error, :not_found}
  def get_working_group_by_slug(slug) do
    case Repo.one(Query.get_working_group_by_slug(slug)) do
      %WorkingGroup{} = wg -> {:ok, wg}
      _ -> {:error, :not_found}
    end
  end

  @spec create_working_group(map()) :: {:ok, WorkingGroup.t()} | {:error, Ecto.Changeset.t()}
  def create_working_group(attrs) do
    %WorkingGroup{}
    |> WorkingGroup.changeset(attrs)
    |> Repo.insert()
  end

  @spec change_working_group(WorkingGroup.t(), map()) :: Ecto.Changeset.t()
  def change_working_group(%WorkingGroup{} = wg, attrs \\ %{}) do
    WorkingGroup.changeset(wg, attrs)
  end

  @spec update_working_group(WorkingGroup.t(), map()) ::
          {:ok, WorkingGroup.t()} | {:error, Ecto.Changeset.t()}
  def update_working_group(%WorkingGroup{} = wg, attrs) do
    wg
    |> WorkingGroup.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_working_group(WorkingGroup.t()) ::
          {:ok, WorkingGroup.t()} | {:error, Ecto.Changeset.t()}
  def delete_working_group(%WorkingGroup{} = wg) do
    Repo.delete(wg)
  end

  @spec create_working_group_volunteer(map) ::
          {:ok, WorkingGroupVolunteer.t()} | {:error, Ecto.Changeset.t()}
  def create_working_group_volunteer(attrs) do
    %WorkingGroupVolunteer{}
    |> WorkingGroupVolunteer.changeset(attrs)
    |> Repo.insert()
  end

  @spec create_working_group_chair(map) ::
          {:ok, WorkingGroupChair.t()} | {:error, Ecto.Changeset.t()}
  def create_working_group_chair(attrs) do
    %WorkingGroupChair{}
    |> WorkingGroupChair.changeset(attrs)
    |> Repo.insert()
  end

  @spec list_board_members() :: [Volunteer.t()]
  def list_board_members(), do: Repo.all(Query.all_board_members())

  def list_sponsors, do: Repo.all(Sponsor)

  def get_sponsor!(id), do: Repo.get!(Sponsor, id)

  def create_sponsor(attrs \\ %{}) do
    %Sponsor{}
    |> Sponsor.changeset(maybe_upload_image(attrs))
    |> Repo.insert()
  end

  def update_sponsor(%Sponsor{} = sponsor, attrs) do
    sponsor
    |> Sponsor.update_changeset(maybe_upload_image(sponsor.name, attrs))
    |> Repo.update()
  end

  def delete_sponsor(%Sponsor{} = sponsor) do
    Repo.delete(sponsor)
  end

  def change_sponsor(%Sponsor{} = sponsor, attrs \\ %{}) do
    Sponsor.changeset(sponsor, attrs)
  end

  defp maybe_upload_image(%{"name" => name} = attrs), do: maybe_upload_image(name, attrs)

  defp maybe_upload_image(%{name: name} = attrs), do: maybe_upload_image(name, attrs)

  defp maybe_upload_image(sponsor_name, %{"logo" => %Plug.Upload{} = upload} = params) do
    content = File.read!(upload.path)
    filename = sponsor_image_filename(sponsor_name, upload.content_type)
    {:ok, url} = Storage.upload_sponsor_image(filename, content)
    Map.put(params, "logo_url", url)
  end

  defp maybe_upload_image(_, attrs), do: attrs

  defp sponsor_image_filename(sponsor_name, <<"image/", ext::binary>>) do
    sponsor_name <> "-" <> Ecto.UUID.generate() <> "." <> ext
  end
end
