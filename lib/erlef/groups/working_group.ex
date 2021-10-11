defmodule Erlef.Groups.WorkingGroup do
  @moduledoc """
  Erlef.WorkingGroup schema
  """

  use Erlef.Schema
  alias Erlef.Groups.{WorkingGroupChair, WorkingGroupVolunteer, Volunteer}

  schema "working_groups" do
    field(:active, :boolean, default: true)
    field(:name, :string)
    field(:slug, :string)
    field(:description, :string)
    field(:formed, :date)
    field(:charter, :string)
    field(:charter_html, :string)
    field(:created_by, Ecto.UUID)
    field(:updated_by, Ecto.UUID)

    embeds_one(:meta, Meta, primary_key: false, on_replace: :update) do
      field(:email, :string)
      field(:github, :string)
      field(:gcal_url, :string)
      field(:google_group, :string)
      field(:erlef_slack_channel, :string)
      field(:public_calendar, :string)
      field(:private_calendar, :string)
    end

    embeds_many(:charter_versions, CharterVersion) do
      field(:charter, :string)
      field(:updated_by, Ecto.UUID)
      timestamps()
    end

    many_to_many(:chairs, Volunteer,
      join_through: WorkingGroupChair,
      on_delete: :delete_all
    )

    many_to_many(:volunteers, Volunteer,
      join_through: WorkingGroupVolunteer,
      on_delete: :delete_all
    )

    timestamps()
  end

  alias Erlef.Groups.WorkingGroup.CharterVersion

  @required [:name, :slug, :description, :formed, :charter]
  @optional [:created_by, :updated_by, :active]
  @permitted @required ++ @optional

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @permitted)
    |> cast_embed(:meta, with: &meta_changeset/2)
    |> validate_required(@required)
    |> maybe_gen_html()
    |> maybe_save_charter_version(params)
  end

  defp maybe_gen_html(%{changes: %{charter: charter}} = cs) do
    charter = HtmlSanitizeEx.markdown_html(charter)
    {:ok, html, _} = Earmark.as_html(charter)

    cs
    |> put_change(:charter, charter)
    |> put_change(:charter_html, html)
  end

  defp maybe_gen_html(cs), do: cs

  defp maybe_save_charter_version(%{data: %{id: nil}} = cs, _params), do: cs

  defp maybe_save_charter_version(cs, %{"updated_by" => updated_by}) do
    maybe_save_charter_version(cs, %{updated_by: updated_by})
  end

  defp maybe_save_charter_version(%{changes: %{charter: charter}} = cs, %{updated_by: updated_by}) do
    case charter == cs.data.charter do
      true ->
        cs

      false ->
        versions = cs.data.charter_versions || []
        ver = %CharterVersion{charter: cs.data.charter, updated_by: updated_by}
        put_embed(cs, :charter_versions, [ver | versions])
    end
  end

  defp maybe_save_charter_version(cs, _params), do: cs

  defp meta_changeset(schema, params) do
    schema
    |> cast(params, [
      :erlef_slack_channel,
      :github,
      :gcal_url,
      :google_group,
      :email,
      :public_calendar,
      :private_calendar
    ])
    |> validate_url(:slack_erlef_channel)
    |> validate_url(:public_calendar)
    |> validate_url(:private_calendar)
    |> validate_url(:gcal_url)
    |> validate_url(:google_group)
    |> validate_email(:email)
  end
end
