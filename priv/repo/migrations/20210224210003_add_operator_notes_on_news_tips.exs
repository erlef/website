defmodule Erlef.Repo.Migrations.AddOperatorNotesOnNewsTips do
  use Ecto.Migration

  def change do
    alter table(:news_tips) do 
      add :operator_notes, :map
    end
  end
end
