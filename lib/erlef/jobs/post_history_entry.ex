defmodule Erlef.Jobs.PostHistoryEntry do
  @moduledoc false

  use Erlef.Schema

  alias Ecto.Changeset
  alias Erlef.Jobs.IntervalType
  alias Erlef.Jobs.TstzRangeType
  alias Erlef.Jobs.URIType
  alias Erlef.Jobs.Post

  import Ecto.Changeset
  import Ecto.Query

  @required_fields [:created_by]
  @optional_fields [
    :id,
    :title,
    :description,
    :position_type,
    :approved,
    :website,
    :approved,
    :city,
    :region,
    :country,
    :remote,
    :deleted_by
  ]
  @fields @required_fields ++ @optional_fields

  @primary_key {:hid, :binary_id, autogenerate: true}
  schema "job_posts_history" do
    field(:title, :string)
    field(:description, :string)
    field(:position_type, Ecto.Enum, values: [:permanent, :contractor])
    field(:approved, :boolean)
    field(:city, :string)
    field(:region, :string)
    field(:country, :string)
    field(:postal_code, :string)
    field(:remote, :boolean)
    field(:website, URIType)
    field(:ttl, IntervalType)

    field(:created_by, :binary_id)
    field(:deleted_by, :binary_id)
    field(:created_at, :utc_datetime)
    field(:deleted_at, :utc_datetime)
    field(:valid_range, TstzRangeType)

    belongs_to(:post, Post, foreign_key: :id)
  end

  @spec changeset(map(), map()) :: Changeset.t()
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:id)
  end

  def from(query \\ __MODULE__) do
    from(query, as: :post_history)
  end

  def where_is_currently_valid(query \\ from()) do
    where(
      query,
      [post_history: ph],
      fragment("?::tstzrange @> current_timestamp", ph.valid_range)
    )
  end
end
