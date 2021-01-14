defmodule Erlef.Groups.WorkingGroup do
  @moduledoc """
  Erlef.WorkingGroup schema
  """

  use Erlef.Schema
  alias Erlef.Groups.{WorkingGroupChair, WorkingGroupVolunteer, Volunteer}

  schema "working_groups" do
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
      field(:public_calendar, :string)
      field(:private_calendar, :string)
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

  @required [:name, :slug, :description, :formed, :charter]
  @optional [:created_by, :updated_by]
  @permitted @required ++ @optional

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @permitted)
    |> cast_embed(:meta, with: &meta_changeset/2)
    |> validate_required(@required)
    |> maybe_gen_html()
  end

  defp maybe_gen_html(%{changes: %{charter: charter}} = cs) do
    charter = HtmlSanitizeEx.strip_tags(charter)
    {:ok, html, _} = Earmark.as_html(charter)

    cs
    |> put_change(:charter, charter)
    |> put_change(:charter_html, html)
  end

  defp maybe_gen_html(cs), do: cs

  defp meta_changeset(schema, params) do
    schema
    |> cast(params, [:github, :gcal_url, :email, :public_calendar, :private_calendar])
    |> validate_url(:public_calendar)
    |> validate_url(:private_calendar)
    |> validate_url(:gcal_url)
    |> validate_email(:email)
  end
end
