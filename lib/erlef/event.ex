defmodule Erlef.Event do
  @moduledoc """
  Erlef.Event schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field(:title, :string)
    field(:slug, :string)
    field(:datetime, :utc_datetime)
    field(:start, :utc_datetime)
    field(:end, :utc_datetime)
    field(:offset, :string)
    field(:event_url, :string)
    field(:gcal_url, :string)
    field(:gmap_embed_url, :string)
    field(:organizer, :string)
    field(:organizer_url, :string)
    field(:organizer_brand_color, :string)
    field(:organizer_brand_logo, :string)
    field(:venue_name, :string)
    field(:venue_url, :string)
    field(:venue_territory, :string)
    field(:venue_gmap_url, :string)
    field(:venue_address1, :string)
    field(:venue_address2, :string)
    field(:venue_city, :string)
    field(:venue_postal_code, :string)
    field(:venue_country, :string)
    field(:excerpt, :string, default: "")
    field(:body, :string, default: "")
    field(:excerpt_html, :string, default: "")
    field(:body_html, :string, default: "")
  end

  @required_fields ~w(title slug datetime start end organizer organizer_url excerpt body excerpt_html body_html)a

  @optional_fields ~w(gcal_url gmap_embed_url venue_url venue_name venue_country venue_address1
      venue_address2 venue_city venue_postal_code venue_territory venue_gmap_url offset event_url organizer_brand_logo organizer_brand_color)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
