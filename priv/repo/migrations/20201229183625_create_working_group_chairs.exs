defmodule Erlef.Repo.Migrations.CreateWorkingGroupChairs do
  use Ecto.Migration

  def change do
    create table(:working_group_chairs) do
      add(:working_group_id, references(:working_groups), null: false)
      add(:volunteer_id, references(:volunteers), null: false)
    end

    create(unique_index("working_group_chairs", [:working_group_id, :volunteer_id]))

    execute("""
    INSERT INTO working_group_chairs (id, working_group_id, volunteer_id)
    SELECT uuid_generate_v4(), working_group_id, volunteer_id from working_group_volunteers 
    WHERE is_chair = true
    """)
  end
end
