defmodule Erlef.Data.Repo.Migrations.CreateAcademicPapers do
  use Ecto.Migration

  def change do
    create table(:academic_papers) do
      add(:title, :string, null: false)
      add(:author, :string, null: false)
      add(:language, :string, null: false)
      add(:url, :string, null: false)
      add(:pay_wall?, :boolean, default: false)
      add(:description, :text)
      add(:technologies, {:array, :string})

      add(:published_at, :utc_datetime)
      add(:deleted_at, :utc_datetime)

      timestamps()
    end
  end
end
