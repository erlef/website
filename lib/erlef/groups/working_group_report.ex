defmodule Erlef.Groups.WorkingGroupReport do
  @moduledoc false

  use Erlef.Schema
  alias Erlef.Groups.{WorkingGroup, Volunteer}

  schema "working_group_reports" do
    field(:type, Ecto.Enum, values: [:quarterly])
    field(:file, :string, virtual: true)
    field(:content, :string)
    field(:is_private, :boolean, default: true)
    field(:meta, :map)
    belongs_to(:submitted_by, Volunteer)
    belongs_to(:working_group, WorkingGroup)
    timestamps()
  end

  @required [:type, :content, :submitted_by_id, :working_group_id]
  @optional [:is_private, :meta]
  @permitted @required ++ @optional

  @doc false
  def changeset(working_group_report, attrs) do
    working_group_report
    |> cast(attrs, @permitted)
    |> validate_required(@required)
  end
end
