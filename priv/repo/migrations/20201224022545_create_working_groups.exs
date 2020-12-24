defmodule Erlef.Repo.Migrations.CreateWorkingGroups do
  use Ecto.Migration

  def change do
    create table(:working_groups) do 
      add :name, :string, null: false
      add :slug, :string, null: false
      add :description, :text, null: false
      add :proposal, :text, null: false
      add :proposal_html, :text, null: false
      add :formed, :date, null: false
      add :meta, :map, null: false, default: %{}
    end
    create unique_index("working_groups", [:name])
    create unique_index("working_groups", [:slug])
  end
end
