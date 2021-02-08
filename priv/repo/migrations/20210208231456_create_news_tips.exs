defmodule Erlef.Repo.Migrations.CreateNewsTips do
  use Ecto.Migration

  def change do
    create table(:news_tips) do
      add :type, :string, null: false
      add :status, :string, null: false
      add :who, :text, null: false
      add :what, :text, null: false
      add :why, :text, null: false
      add :at_when, :text, null: false
      add :at_where, :text, null: false
      add :how, :text, null: false
      add :additional_info, :text
      add :supporting_documents, :map
      add :notes, :map
      add :flags, :map
      add :priority, :integer
      add :assigned_to_id, references(:members, on_delete: :nothing)
      add :created_by_id, references(:members, on_delete: :nothing)
      add :updated_by_id, references(:members, on_delete: :nothing)
      add :processed_by_id, references(:members, on_delete: :nothing)
      add :logs, :map
      timestamps()
    end

    create index(:news_tips, [:assigned_to_id])
    create index(:news_tips, [:created_by_id])
    create index(:news_tips, [:updated_by_id])
    create index(:news_tips, [:processed_by_id])
  end
end
