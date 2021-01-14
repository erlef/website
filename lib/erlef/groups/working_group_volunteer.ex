defmodule Erlef.Groups.WorkingGroupVolunteer do
  @moduledoc """
  Erlef.WorkingGroupVolunteer schema
  """

  use Erlef.Schema

  alias Erlef.Groups.{WorkingGroup, Volunteer}

  schema "working_group_volunteers" do
    belongs_to(:working_group, WorkingGroup, on_replace: :delete)
    belongs_to(:volunteer, Volunteer, on_replace: :delete)
    timestamps()
  end

  @required_fields [:working_group_id, :volunteer_id]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:working_group_id,
      name: "working_group_volunteers_working_group_id_fkey"
    )
    |> foreign_key_constraint(:volunteer_id, name: "working_group_volunteers_volunteer_id_fkey")
  end
end
