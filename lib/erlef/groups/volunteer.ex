defmodule Erlef.Groups.Volunteer do
  @moduledoc """
  Erlef.Volunteer schema
  """

  use Erlef.Schema

  schema "volunteers" do
    field(:member_id, Ecto.UUID)
    field(:name, :string)
    field(:avatar_url, :string)

    many_to_many(:working_groups, Erlef.Groups.WorkingGroup,
      join_through: Erlef.Groups.WorkingGroupVolunteer,
      on_delete: :delete_all
    )
  end

  @required_fields [:name]
  @optional_fields [:avatar_url, :member_id]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
