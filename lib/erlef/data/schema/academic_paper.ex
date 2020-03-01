defmodule Erlef.Data.Schema.AcademicPaper do
  @moduledoc """
  Schema module for academic papers
  """
  use Erlef.Data.Schema

  @type t :: %__MODULE__{
          id: binary(),
          title: String.t(),
          author: String.t(),
          language: String.t(),
          url: String.t(),
          pay_wall?: :boolean | nil,
          description: String.t() | nil,
          technologies: {:array, String.t()} | nil,
          original_publish_date: Date.t() | nil,
          published_at: :utc_datetime | nil,
          deleted_at: :utc_datetime | nil
        }

  @required_fields ~w|
    title
    author
    language
    url
  |a

  @optional_fields ~w|
    pay_wall?
    description
    technologies
    original_publish_date
    published_at
    deleted_at
  |a

  @all_fields @required_fields ++ @optional_fields

  schema "academic_papers" do
    field(:title, :string)
    field(:author, :string)
    field(:language, :string)
    field(:url, :string)
    field(:pay_wall?, :boolean)
    field(:description, :string)
    field(:technologies, {:array, :string})
    field(:original_publish_date, :date)

    field(:published_at, :utc_datetime)
    field(:deleted_at, :utc_datetime)

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
  end
end
