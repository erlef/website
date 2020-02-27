defmodule Erlef.Data.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
    add(:title, :string)
    add(:slug, :string)
    add(:datetime, :utc_datetime)
    add(:start, :utc_datetime)
    add(:end, :utc_datetime)
    add(:offset, :string)
    add(:event_url, :string)
    add(:gcal_url, :string)
    add(:gmap_embed_url, :string)
    add(:organizer, :string)
    add(:organizer_url, :string)
    add(:organizer_brand_color, :string)
    add(:organizer_brand_logo, :string)
    add(:venue_name, :string)
    add(:venue_url, :string)
    add(:venue_territory, :string)
    add(:venue_gmap_url, :string)
    add(:venue_address1, :string)
    add(:venue_address2, :string)
    add(:venue_city, :string)
    add(:venue_postal_code, :string)
    add(:venue_country, :string)
    add(:excerpt, :string, default: "")
    add(:body, :string, default: "")
    add(:excerpt_html, :string, default: "")
    add(:body_html, :string, default: "")
    end
  end
end
