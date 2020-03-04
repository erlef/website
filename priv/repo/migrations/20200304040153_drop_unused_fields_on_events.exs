defmodule Erlef.Data.Repo.Migrations.DropUnusedFieldsOnEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      remove(:excerpt)
      remove(:organizer_url)
      remove(:venue_name)
      remove(:venue_url)
      remove(:venue_city)
      remove(:venue_postal_code)
      remove(:venue_country)
      remove(:venue_territory)
      remove(:venue_gmap_embed_url)
      remove(:venue_address1)
      remove(:venue_address2)
      remove(:venue_address3)
    end
  end
end
