defmodule Erlef.Repo.Migrations.CreateSponsors do
  use Ecto.Migration

  def change do
    create table(:sponsors) do
      add :name, :string
      add :is_founding_sponsor, :boolean, default: false, null: false
      add :url, :string
      add :logo_url, :string

      timestamps()
    end
    
    create unique_index("sponsors", [:name])
    create unique_index("sponsors", [:url])
    create unique_index("sponsors", [:logo_url])
 
  end
end
