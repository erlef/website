defmodule Erlef.Groups do
  @moduledoc """
  Erlef.Groups is a context module for working with various types of groups in the erlef system.

  ## Types of groups

  - working groups, volunteers, and chairs
  - sponsors
  - board and board members

  ## Audit support

   - All functions that create or update a resource require a keyword list which in turn
     must provide an audit k/v. Of which the value of audit is to be a map which must include 
     the id of the member (`member_id`) who is modifying the resource. 

  This module imports helpers from Erlef.Context to aid in working with audit data.

  ## Terminology 

  - wg : Abbreviation for working group
  - vol : Abbreviation for volunteer
  - wgc: Abbreviation for working group chair
  - wgv : Abbreviation forr working group volunteer

  """

  alias Ecto.Multi
  alias Erlef.{Repo, Storage}
  alias Erlef.Accounts.Member

  alias Erlef.Groups.{
    GitReport,
    Volunteer,
    WorkingGroup,
    WorkingGroupChair,
    WorkingGroupReport,
    WorkingGroupVolunteer,
    Query,
    Sponsor
  }

  require Logger
  import Erlef.Context

  ### Volunteers ###

  @spec list_volunteers() :: [Volunteer.t()]
  def list_volunteers(), do: Repo.all(Volunteer)

  @spec get_volunteer(Ecto.UUID.t()) :: WorkingGroup.t()
  def get_volunteer(id), do: Repo.get(Volunteer, id)

  @spec get_volunteer!(Ecto.UUID.t()) :: WorkingGroup.t()
  def get_volunteer!(id), do: Repo.get!(Volunteer, id)

  @spec get_volunteer_by_member_id(Ecto.UUID.t()) :: WorkingGroup.t()
  def get_volunteer_by_member_id(member_id) do
    Repo.one(Query.get_volunteer_by_member_id(member_id))
  end

  @spec change_volunteer(Volunteer.t(), map()) :: Ecto.Changeset.t()
  def change_volunteer(%Volunteer{} = vol, attrs \\ %{}) do
    Volunteer.changeset(vol, attrs)
  end

  @spec create_volunteer(map(), Keyword.t()) ::
          {:ok, Volunteer.t()} | {:error, Ecto.Changeset.t()}
  def create_volunteer(attrs, audit: audit) do
    %Volunteer{}
    |> Volunteer.changeset(maybe_upload_image(audit_attrs(:create, attrs, audit)))
    |> Repo.insert()
  end

  @spec update_volunteer(Volunteer.t(), map(), Keyword.t()) ::
          {:ok, Volunteer.t()} | {:error, Ecto.Changeset.t()}
  def update_volunteer(%Volunteer{} = vol, attrs, audit: audit) do
    vol
    |> Volunteer.changeset(maybe_upload_image(audit_attrs(:update, attrs, audit)))
    |> Repo.update()
  end

  @spec delete_volunteer(Volunteer.t()) :: {:ok, Volunteer.t()} | {:error, Ecto.Changeset.t()}
  def delete_volunteer(%Volunteer{} = vol) do
    Repo.delete(vol)
  end

  ### Working groups ###

  @spec list_working_groups() :: [WorkingGroup.t()]
  def list_working_groups(), do: Repo.all(Query.all_working_groups())

  @spec get_working_group(Ecto.UUID.t()) :: WorkingGroup.t() | nil
  def get_working_group(id), do: Repo.one(Query.get_wg_by_id(id))

  @spec get_working_group!(Ecto.UUID.t()) :: WorkingGroup.t() | nil
  def get_working_group!(id), do: Repo.one!(Query.get_wg_by_id(id))

  @spec get_working_group_by_slug(String.t()) :: {:ok, WorkingGroup.t()} | {:error, :not_found}
  def get_working_group_by_slug(slug) do
    case Repo.one(Query.get_wg_by_slug(slug)) do
      %WorkingGroup{} = wg -> {:ok, wg}
      _ -> {:error, :not_found}
    end
  end

  @spec change_working_group(WorkingGroup.t(), map()) :: Ecto.Changeset.t()
  def change_working_group(%WorkingGroup{} = wg, attrs \\ %{}) do
    WorkingGroup.changeset(wg, attrs)
  end

  @spec create_working_group(map(), Keyword.t()) ::
          {:ok, WorkingGroup.t()} | {:error, Ecto.Changeset.t()}
  def create_working_group(attrs, audit: audit) do
    %WorkingGroup{}
    |> WorkingGroup.changeset(audit_attrs(:create, attrs, audit))
    |> Repo.insert()
  end

  @spec update_working_group(WorkingGroup.t(), map(), Keyword.t()) ::
          {:ok, WorkingGroup.t()} | {:error, Ecto.Changeset.t()}
  def update_working_group(%WorkingGroup{} = wg, attrs, audit: audit) do
    wg
    |> WorkingGroup.changeset(audit_attrs(:update, attrs, audit))
    |> Repo.update()
  end

  ### Working group volunteers ###

  @spec create_wg_volunteer(WorkingGroup.t(), map(), Keyword.t()) ::
          {:ok, WorkingGroupVolunteer.t()} | {:error, Ecto.Changeset.t()}
  def create_wg_volunteer(wg, volunteer, audit: audit) do
    audit_attrs = %{updated_by: audit.member_id}

    attrs = %{working_group_id: wg.id, volunteer_id: volunteer.id}

    res =
      Multi.new()
      |> Multi.insert(
        :working_group_volunteer,
        WorkingGroupVolunteer.changeset(%WorkingGroupVolunteer{}, attrs)
      )
      |> Multi.update(:working_group, WorkingGroup.changeset(wg, audit_attrs))
      |> Repo.transaction()

    case res do
      {:ok, %{working_group_volunteer: wgv}} -> {:ok, wgv}
      err -> err
    end
  end

  @spec get_wg_volunteer!(Ecto.UUID.t(), Ecto.UUID.t()) :: WorkingGroupVolunteer.t()
  def get_wg_volunteer!(wg_id, volunteer_id) do
    Repo.one!(Query.get_wg_volunteer(wg_id, volunteer_id))
  end

  @spec delete_wg_volunteer(WorkingGroup.t(), WorkingGroupVolunteer.t(), Keyword.t()) ::
          {:ok, WorkingGroupVolunteer.t()} | {:error, Ecto.Changeset.t()}
  def delete_wg_volunteer(wg, wgv, audit: audit) do
    audit_attrs = %{updated_by: audit.member_id}

    Multi.new()
    |> Multi.delete(:working_group_volunteer, wgv)
    |> Multi.update(:working_group, WorkingGroup.changeset(wg, audit_attrs))
    |> Repo.transaction()
  end

  @spec is_volunteer?(WorkingGroup.t(), Volunteer.t() | Member.t() | Ecto.UUID.t()) :: boolean()
  def is_volunteer?(wg, %Volunteer{member_id: member_id}) do
    is_volunteer?(wg, member_id)
  end

  def is_volunteer?(wg, %Member{id: member_id}) do
    is_volunteer?(wg, member_id)
  end

  def is_volunteer?(%WorkingGroup{volunteers: volunteers}, member_id) when is_binary(member_id) do
    Enum.any?(volunteers, fn v -> v.member_id == member_id end)
  end

  def is_volunteer?(_wg, _member_or_id), do: false

  ### Working group chairs ###

  @spec create_wg_chair(WorkingGroup.t(), Volunteer.t(), Keyword.t()) ::
          {:ok, WorkingGroupChair.t()} | {:error, Ecto.Changeset.t()}
  def create_wg_chair(wg, volunteer, audit: audit) do
    audit_attrs = %{updated_by: audit.member_id}

    attrs = %{working_group_id: wg.id, volunteer_id: volunteer.id}

    res =
      Multi.new()
      |> Multi.insert(
        :working_group_chair,
        WorkingGroupChair.changeset(%WorkingGroupChair{}, attrs)
      )
      |> Multi.update(:working_group, WorkingGroup.changeset(wg, audit_attrs))
      |> Repo.transaction()

    case res do
      {:ok, %{working_group_chair: wgc}} -> {:ok, wgc}
      err -> err
    end
  end

  @spec delete_wg_chair(WorkingGroup.t(), WorkingGroupChair.t(), Keyword.t()) ::
          {:ok, WorkingGroupChair.t()} | {:error, Ecto.Changeset.t()}
  def delete_wg_chair(wg, wgc, audit: audit) do
    audit_attrs = %{updated_by: audit.member_id}

    Multi.new()
    |> Multi.delete(:working_group_chair, wgc)
    |> Multi.update(:working_group, WorkingGroup.changeset(wg, audit_attrs))
    |> Repo.transaction()
  end

  @spec get_wg_chair!(Ecto.UUID.t(), Ecto.UUID.t()) :: WorkingGroupChair.t()
  def get_wg_chair!(wg_id, volunteer_id) do
    Repo.one!(Query.get_wg_chair(wg_id, volunteer_id))
  end

  @spec is_chair?(WorkingGroup.t(), Volunteer.t() | Member.t() | Ecto.UUID.t()) :: boolean()
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

  ### Board ###

  @spec list_board_members() :: [Volunteer.t()]
  def list_board_members(), do: Repo.all(Query.all_board_members())

  ### Sponsors ###

  @spec list_sponsors() :: [Sponsor.t()]
  def list_sponsors, do: Repo.all(Sponsor)

  @spec get_sponsor!(Ecto.UUID.t()) :: Sponsor.t()
  def get_sponsor!(id), do: Repo.get!(Sponsor, id)

  @spec create_sponsor(map(), Keyword.t()) :: {:ok, Sponsor.t()} | {:error, Ecto.Changeset.t()}
  def create_sponsor(attrs \\ %{}, audit: audit) do
    %Sponsor{}
    |> Sponsor.changeset(maybe_upload_image(audit_attrs(:create, attrs, audit)))
    |> Repo.insert()
  end

  @spec update_sponsor(Sponsor.t(), map(), Keyword.t()) ::
          {:ok, Sponsor.t()} | {:error, Ecto.Changeset.t()}
  def update_sponsor(%Sponsor{} = sponsor, attrs, audit: audit) do
    sponsor
    |> Sponsor.update_changeset(
      maybe_upload_image(sponsor.name, audit_attrs(:update, attrs, audit))
    )
    |> Repo.update()
  end

  @spec change_sponsor(Sponsor.t(), map | nil) :: Ecto.Changeset.t()
  def change_sponsor(%Sponsor{} = sponsor, attrs \\ %{}) do
    Sponsor.changeset(sponsor, attrs)
  end

  ### Working Group Reports ###

  @spec list_wg_reports_by_member_id(Ecto.UUID.t()) :: [WorkingGroupReport.t()]
  def list_wg_reports_by_member_id(member_id) do
    Repo.all(Query.get_wg_report_by_member_id(member_id))
  end

  @spec get_wg_report!(Ecto.UUID.t()) :: WorkingGroupReport.t()
  def get_wg_report!(id), do: Repo.get!(WorkingGroupReport, id)

  @spec get_wg_report_for_member!(Ecto.UUID.t(), Ecto.UUID.t()) :: WorkingGroupReport.t()
  def get_wg_report_for_member!(id, member_id) do
    wg_report = Repo.get_by!(WorkingGroupReport, id: id, member_id: member_id)

    case GitReport.get_status(wg_report) do
      {:ok, _status} ->
        wg_report

      {:changed, status} ->
        wg_report
        |> WorkingGroupReport.changeset(%{status: status})
        |> Repo.update!()

      {:error, _} = err ->
        Logger.error(fn -> "Error getting report status : #{err}" end)
        raise "Error getting report status"
    end
  end

  @spec create_wg_report(map(), Keyword.t()) ::
          {:ok, WorkingGroupReport.t()} | {:error, Ecto.Changeset.t()} | {:error, term()}
  def create_wg_report(attrs, _opts \\ []) do
    cs = WorkingGroupReport.changeset(%WorkingGroupReport{}, attrs)

    res =
      Multi.new()
      |> Multi.insert(:report, cs)
      |> Multi.run(:git_report, &submit_git_report/2)
      |> Multi.update(:meta, fn changes ->
        WorkingGroupReport.changeset(changes.report, %{meta: changes.git_report})
      end)
      |> Repo.transaction()

    case res do
      {:ok, %{report: report}} -> {:ok, report}
      {:error, :report, cs, _changes} -> {:error, cs}
      {:error, :meta, cs, _changes} -> {:error, cs}
      err -> err
    end
  end

  @spec update_wg_report(Ecto.Repo.t(), WorkingGroupReport.t(), map(), Keyword.t()) ::
          {:ok, WorkingGroupReport.t()} | {:error, Ecto.Changeset.t()}
  def update_wg_report(repo, %WorkingGroupReport{} = wg_report, attrs, audit: data) do
    audit_attrs = Map.put(attrs, :updated_by, data.member_id)

    wg_report
    |> WorkingGroupReport.changeset(audit_attrs)
    |> repo.update()
  end

  @spec update_wg_report(WorkingGroupReport.t(), map()) ::
          {:ok, WorkingGroupReport.t()} | {:error, Ecto.Changeset.t()}
  def update_wg_report(%WorkingGroupReport{} = wg_report, attrs) do
    cs = WorkingGroupReport.update_changeset(wg_report, attrs)

    case cs.valid? do
      true ->
        Repo.transaction(fn ->
          case GitReport.update(Ecto.Changeset.apply_changes(cs)) do
            {:ok, meta} ->
              wg_report
              |> WorkingGroupReport.update_changeset(put_meta(attrs, meta))
              |> Repo.update!()

            err ->
              err
          end
        end)

      false ->
        {:error, cs}
    end
  end

  def change_wg_report(%WorkingGroupReport{} = working_group_report, attrs \\ %{}) do
    WorkingGroupReport.changeset(working_group_report, attrs)
  end

  ### Private ###

  defp maybe_upload_image(%{"avatar" => %Plug.Upload{} = upload} = params) do
    content = File.read!(upload.path)
    filename = unique_image_filename(upload.content_type)
    {:ok, url} = Storage.upload_avatar_image(filename, content)
    Map.put(params, "avatar_url", url)
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

  defp put_meta(attrs, meta) do
    case all_atoms_map?(attrs) do
      true ->
        Map.put(attrs, :meta, meta)

      false ->
        Map.put(attrs, "meta", meta)
    end
  end

  defp sponsor_image_filename(sponsor_name, <<"image/", ext::binary>>) do
    sponsor_name <> "-" <> Ecto.UUID.generate() <> "." <> ext
  end

  defp unique_image_filename(<<"image/", ext::binary>>) do
    Ecto.UUID.generate() <> "." <> ext
  end

  defp submit_git_report(repo, %{report: report}) do
    report = repo.preload(report, [:working_group, :submitted_by])

    case GitReport.submit(report) do
      {:ok, meta} ->
        {:ok, meta}

      err ->
        Logger.error(fn -> "Error submitting git report => #{err}" end)
        {:error, :git_report_creation_failed}
    end
  end
end
