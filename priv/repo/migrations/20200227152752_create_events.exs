defmodule Erlef.Data.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:title, :string, null: false)
      add(:excerpt, :string, null: false)
      add(:description, :string, null: false)
      add(:slug, :string, null: false)
      add(:start, :utc_datetime, null: false)
      add(:end, :utc_datetime, null: false)
      add(:offset, :string, null: false)
      add(:url, :string, null: false)
      add(:organizer, :string)
      add(:organizer_url, :string)
      add(:organizer_brand_color, :string)
      add(:organizer_brand_logo, :string)
      add(:gcal_url, :string)
      add(:gmap_embed_url, :string)
      add(:venue_name, :string)
      add(:venue_url, :string)
      add(:venue_city, :string)
      add(:venue_postal_code, :string)
      add(:venue_country, :string)
      add(:venue_territory, :string)
      add(:venue_gmap_url, :string)
      add(:venue_address1, :string)
      add(:venue_address2, :string)
      add(:venue_address3, :string)
      add(:submitted_by, :integer, null: false)
      add(:approved, :boolean, null: false, default: false)
      add(:approved_by, :integer)
      timestamps()
    end

    create unique_index("event", [:title])
  end
end
