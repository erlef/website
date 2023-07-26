defmodule Erlef.Repo.Migrations.AlterTableAcademicPapersAddFields do
  use Ecto.Migration
    
  def change do
    alter table(:academic_papers) do
      add :submitted_by, references(:members), null: true
      add :approved_by, references(:members), null: true
    end

    execute("UPDATE academic_papers SET submitted_by = null, approved_by = null")
  end

end
