defmodule Erlef.Community.Event do
  @moduledoc """
  Erlef.Community.Event schema
  """
  use Erlef.Schema

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          type: atom() | String.t(),
          title: String.t(),
          description: String.t(),
          slug: String.t(),
          url: :uri_string.uri_string(),
          start: Date.t(),
          end: Date.t(),
          organizer: String.t(),
          organizer_brand_color: String.t(),
          organizer_brand_logo: String.t() | nil,
          submitted_by_id: Ecto.UUID.t(),
          approved: boolean() | nil,
          approved_by_id: Ecto.UUID.t() | nil,
          approved_at: DateTime.t() | nil
        }

  @required_fields [
    :title,
    :description,
    :start,
    :end,
    :organizer,
    :url,
    :type,
    :submitted_by_id
  ]

  @optional_fields [
    :id,
    :organizer_brand_color,
    :organizer_brand_logo,
    :approved_by_id
  ]

  @all_fields @required_fields ++ @optional_fields

  schema "events" do
    field(:type, Ecto.Enum, values: [:conference, :training, :meetup, :hackathon])
    field(:title, :string)
    field(:slug, :string)
    field(:description, :string)
    field(:url, :string)
    field(:start, :date)
    field(:end, :date)
    field(:organizer, :string)
    field(:organizer_brand_color, :string, default: "#efefef")
    field(:organizer_brand_logo, :binary)

    field(:approved, :boolean)

    belongs_to(:submitted_by, Erlef.Accounts.Member)
    belongs_to(:approved_by, Erlef.Accounts.Member)

    field(:approved_at, :utc_datetime)

    timestamps()
  end

  def new_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
  end

  def submission_changeset(%__MODULE__{} = event, params \\ %{}) do
    event
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:title)
    |> maybe_generate_slug()
    |> post_process_description()
  end

  def new_submission(params \\ %{}) do
    %__MODULE__{}
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:title)
    |> maybe_generate_slug()
    |> post_process_description()
  end

  @spec approval_changeset(t(), map()) :: Ecto.Changeset.t()
  def approval_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:approved_by_id])
    |> validate_required([:approved_by_id])
    |> validate_uuid(:approved_by_id)
    |> put_change(:approved, true)
    |> put_change(:approved_at, DateTime.truncate(DateTime.utc_now(), :second))
  end

  def types, do: Ecto.Enum.values(__MODULE__, :type)

  defp maybe_generate_slug(%{changes: %{title: title}, errors: []} = set) do
    put_change(set, :slug, Slug.slugify(title))
  end

  defp maybe_generate_slug(set), do: set

  defp post_process_description(%{changes: %{description: description}, errors: []} = set) do
    {:ok, html, _} = Earmark.as_html(description)
    put_change(set, :description, html)
  end

  defp post_process_description(set), do: set
end
