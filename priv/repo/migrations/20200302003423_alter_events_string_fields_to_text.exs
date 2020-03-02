defmodule Erlef.Data.Repo.Migrations.AlterEventstextFieldsToText do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify(:title, :text, null: false)
      modify(:excerpt, :text, null: false)
      modify(:description, :text, null: false)
      modify(:slug, :text, null: false)
      modify(:url, :text, null: false)
      modify(:organizer, :text)
      modify(:organizer_url, :text)
      modify(:organizer_brand_color, :text)
      modify(:organizer_brand_logo, :text)
      modify(:venue_name, :text)
      modify(:venue_url, :text)
      modify(:venue_city, :text)
      modify(:venue_postal_code, :text)
      modify(:venue_country, :text)
      modify(:venue_territory, :text)
      modify(:venue_gmap_embed_url, :text)
      modify(:venue_address1, :text)
      modify(:venue_address2, :text)
      modify(:venue_address3, :text)
    end
    create unique_index("events", [:slug])
  end
end
