defmodule Erlef.Data.Event do
  @moduledoc """
  Erlef.Data.Event schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "events" do
    field(:approved, :boolean, default: false)
    field(:approved_by, :integer)
    field(:description, :string)
    field(:end, :date)
    field(:excerpt, :string)
    field(:gcal_url, :string)
    field(:gmap_embed_url, :string)
    field(:organizer, :string)
    field(:organizer_brand_color, :string)
    field(:organizer_brand_logo, :string)
    field(:organizer_url, :string)
    field(:slug, :string)
    field(:start, :date)
    field(:submitted_by, :integer)
    field(:title, :string)
    field(:url, :string)
    field(:venue_address1, :string)
    field(:venue_address2, :string)
    field(:venue_address3, :string)
    field(:venue_city, :string)
    field(:venue_country, :string)
    field(:venue_gmap_url, :string)
    field(:venue_name, :string)
    field(:venue_postal_code, :string)
    field(:venue_territory, :string)
    field(:venue_url, :string)
  end

  @required_fields [
    :description,
    :end,
    :excerpt,
    :organizer,
    :slug,
    :start,
    :submitted_by,
    :title,
    :url
  ]

  @optional_fields [
    :approved,
    :approved_by,
    :gcal_url,
    :organizer_brand_color,
    :organizer_brand_logo,
    :organizer_url,
    :venue_address1,
    :venue_address2,
    :venue_address3,
    :venue_city,
    :venue_country,
    :venue_gmap_url,
    :venue_name,
    :venue_url
  ]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> maybe_generate_slug()
  end

  defp maybe_generate_slug(%{changes: %{title: title}, errors: []} = set) do
    put_change(set, :title, Slug.slugify(title))
  end

  defp maybe_generate_slug(set), do: set
end
