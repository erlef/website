defmodule Erlef.Jobs.Post do
  @moduledoc false

  use Erlef.Schema

  alias Ecto.Changeset
  alias Erlef.Jobs.IntervalType
  alias Erlef.Jobs.PostHistoryEntry
  alias Erlef.Jobs.URIType
  alias Erlef.Accounts.Member

  import Ecto.Changeset
  import Ecto.Query

  @required_fields [:title, :description, :position_type, :website]
  @optional_fields [:approved, :city, :region, :country, :remote, :ttl]
  @fields @required_fields ++ @optional_fields

  schema "job_posts" do
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
    field(:ttl, IntervalType, default: %{months: 0, days: 30, secs: 0})
    field(:expired_at, :utc_datetime_usec)
    field(:expired?, :boolean, virtual: true)
    field(:sponsor_id, :binary_id, virtual: true)
    field(:updated_by, :binary_id, virtual: true)

    belongs_to(:author, Member, foreign_key: :created_by)
    has_one(:sponsor, through: [:author, :sponsor])

    has_many(:history_entries, PostHistoryEntry, foreign_key: :id)

    timestamps()
  end

  @spec changeset(map(), map()) :: Changeset.t()
  def changeset(post, attrs) do
    post
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end

  def from(query \\ __MODULE__) do
    query
    |> from(as: :post)
    |> with_author()
    |> with_history_entries()
    |> PostHistoryEntry.where_is_currently_valid()
    |> order_by([post: p], desc: p.inserted_at)
    |> select_merge([post: p, member: a, post_history: ph], %{
      expired?: fragment("? < current_timestamp", p.expired_at),
      sponsor_id: a.sponsor_id,
      updated_by: ph.created_by
    })
  end

  def with_author(query \\ from()) do
    if has_named_binding?(query, :member) do
      query
    else
      join(
        query,
        :left,
        [post: p],
        a in assoc(p, :author),
        as: :member
      )
    end
  end

  def with_history_entries(query \\ from()) do
    if has_named_binding?(query, :post_history) do
      query
    else
      join(
        query,
        :left,
        [post: p],
        ph in assoc(p, :history_entries),
        as: :post_history
      )
    end
  end

  def where_inserted_in_current_year(query \\ from()) do
    where(
      query,
      [post: p],
      fragment("date_part('year', ?) = date_part('year', now())", p.inserted_at)
    )
  end

  def where_approved(query \\ from()) do
    where(query, [post: p], p.approved == true)
  end

  def where_unapproved(query \\ from()) do
    where(query, [post: p], p.approved == false)
  end

  def where_expired(query \\ from()) do
    where(query, [post: p], fragment("current_timestamp > ?", p.expired))
  end

  def where_fresh(query \\ from()) do
    where(query, [post: p], fragment("current_timestamp <= ?", p.expired_at))
  end

  def where_id(query \\ from(), id), do: where(query, id: ^id)

  def where_author_id(query \\ from(), id), do: where(query, [post: p], p.created_by == ^id)

  def order_by_sponsor_owner_asc(query \\ from()) do
    query
    |> with_author()
    |> order_by([member: a],
      asc: fragment("(case when ? is not null then 1 else 0 end)", a.sponsor_id)
    )
  end
end
