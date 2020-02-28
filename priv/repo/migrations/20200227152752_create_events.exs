defmodule Erlef.Data.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:title, :string, null: false)
      add(:slug, :string, null: false)
      add(:datetime, :utc_datetime, null: false)
      add(:start, :utc_datetime, null: false)
      add(:end, :utc_datetime, null: false)
      add(:offset, :string, null: false)
      add(:event_url, :string, null: false)
      add(:organizer, :string, null: false)
      add(:venue_city, :string, null: false)
      add(:venue_postal_code, :string, null: false)
      add(:venue_country, :string, null: false)
      add(:short_description, :string, null: false)
      add(:description, :string, default: "", null: false)
      add(:gcal_url, :string)
      add(:gmap_embed_url, :string)
      add(:organizer_url, :string)
      add(:organizer_brand_color, :string)
      add(:organizer_brand_logo, :string)
      add(:venue_name, :string)
      add(:venue_url, :string)
      add(:venue_territory, :string)
      add(:venue_gmap_url, :string)
      add(:venue_address1, :string)
      add(:venue_address2, :string)
    end
  end
end
