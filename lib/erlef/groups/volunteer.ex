defmodule Erlef.Groups.Volunteer do
  @moduledoc """
  Erlef.Volunteer schema
  """

  use Erlef.Schema

  @type t() :: Ecto.Schema.schema()

  schema "volunteers" do
    field(:member_id, Ecto.UUID)
    field(:name, :string)
    field(:avatar, :string, virtual: true)
    field(:avatar_url, :string)
    field(:is_board_member, :boolean, default: false)
    field(:created_by, Ecto.UUID)
    field(:updated_by, Ecto.UUID)

    many_to_many(:working_groups, Erlef.Groups.WorkingGroup,
      join_through: Erlef.Groups.WorkingGroupVolunteer,
      on_delete: :delete_all
    )

    timestamps()
  end

  @required [:name]
  @optional [:avatar_url, :member_id, :is_board_member, :created_by, :updated_by]
  @permitted @required ++ @optional

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @permitted)
    |> validate_required(@required)
  end
end
