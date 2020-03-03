defmodule Erlef.Data.Repo.Migrations.AlterEventsOrganizerLogoDataType do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify(:organizer_brand_color, :string, size: 7)
    end

    execute("ALTER TABLE events ALTER COLUMN organizer_brand_logo TYPE bytea using (organizer_brand_logo::bytea);")
  end
end
