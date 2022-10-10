defmodule ErlefWeb.JobController.CreatePostForm do
  @moduledoc """
  An embedded Ecto schema for validation and normalization of a form for post
  creation.
  """

  use Ecto.Schema

  alias Erlef.Jobs.URIType

  import Ecto.Changeset

  @required_fields [:title, :description, :position_type, :website]
  @optional_fields [:approved, :city, :region, :country, :remote, :days_to_live]
  @fields @required_fields ++ @optional_fields

  @primary_key false
  embedded_schema do
    field(:title, :string)
    field(:description, :string)
    field(:position_type, Ecto.Enum, values: [:permanent, :contractor])
    field(:approved, :boolean, default: false)
    field(:city, :string)
    field(:region, :string)
    field(:country, :string)
    field(:postal_code, :string)
    field(:remote, :boolean, default: false)
    field(:website, URIType)
    field(:days_to_live, :integer, default: 30)
  end

  def changeset(request \\ %__MODULE__{}, attrs \\ %{}) do
    request
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_number(:days_to_live, greater_than: 0)
  end
end
