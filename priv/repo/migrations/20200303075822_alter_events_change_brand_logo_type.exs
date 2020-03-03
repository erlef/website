defmodule Erlef.Data.Repo.Migrations.AlterEventsChangeBrandLogoType do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify(:organizer_brand_logo, :string)
    end
  end
end
