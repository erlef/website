defmodule Erlef.Data.Event do
  @moduledoc """
  Erlef.Data.Event schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          title: String.t(),
          excerpt: String.t(),
          description: String.t(),
          slug: String.t(),
          url: :uri_string.uri_string(),
          start: Date.t(),
          end: Date.t(),
          organizer: String.t(),
          organizer_brand_color: String.t(),
          organizer_brand_logo: String.t() | nil,
          organizer_url: :uri_string.uri_string() | nil,
          venue_address1: String.t() | nil,
          venue_address2: String.t() | nil,
          venue_address3: String.t() | nil,
          venue_city: String.t() | nil,
          venue_country: String.t() | nil,
          venue_name: String.t() | nil,
          venue_postal_code: String.t() | nil,
          venue_territory: String.t() | nil,
          venue_url: :uri_string.uri_string() | nil,
          venue_gmap_embed_url: :uri_string.uri_string() | nil,
          submitted_by: integer(),
          approved: boolean() | nil,
          approved_by: integer() | nil,
          approved_at: DateTime.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "events" do
    field(:title, :string)
    field(:slug, :string)
    field(:excerpt, :string)
    field(:description, :string)
    field(:url, :string)
    field(:start, :date)
    field(:end, :date)
    field(:organizer, :string)
    field(:organizer_brand_color, :string, default: "#235185")
    field(:organizer_brand_logo, :string)
    field(:organizer_url, :string)
    field(:venue_name, :string)
    field(:venue_address1, :string)
    field(:venue_address2, :string)
    field(:venue_address3, :string)
    field(:venue_city, :string)
    field(:venue_territory, :string)
    field(:venue_country, :string)
    field(:venue_postal_code, :string)
    field(:venue_url, :string)
    field(:venue_gmap_embed_url, :string)
    field(:submitted_by, :integer)
    field(:approved, :boolean, default: false)
    field(:approved_by, :integer)
    field(:approved_at, :utc_datetime)
    timestamps()
  end

  @required_fields [
    :title,
    :excerpt,
    :description,
    :start,
    :end,
    :organizer,
    :url,
    :submitted_by
  ]

  @optional_fields [
    :organizer_brand_color,
    :organizer_brand_logo,
    :organizer_url,
    :venue_address1,
    :venue_address2,
    :venue_address3,
    :venue_city,
    :venue_territory,
    :venue_country,
    :venue_postal_code,
    :venue_gmap_embed_url,
    :venue_name,
    :venue_url
  ]

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields ++ [:approved_by])
    |> validate_required(@required_fields ++ [:approved_by])
    |> unique_constraint(:title)
    |> maybe_generate_slug()
  end

  @spec submission_changeset(t(), map()) :: Ecto.Changeset.t()
  def submission_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> maybe_generate_slug()
  end

  @spec approval_changeset(t(), map()) :: Ecto.Changeset.t()
  def approval_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:approved_by])
    |> validate_required([:approved_by])
    |> put_change(:approved, true)
    |> put_change(:approved_at, DateTime.utc_now())
  end

  defp maybe_generate_slug(%{changes: %{title: title}, errors: []} = set) do
    put_change(set, :slug, Slug.slugify(title))
  end

  defp maybe_generate_slug(set), do: set
end
