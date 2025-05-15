defmodule Erlef.Blogs.Post do
  @moduledoc """
  Erlef.Blog schema
  """

  @type t() :: Ecto.Schema.schema()

  use Ecto.Schema
  import Ecto.Changeset

  schema "blogs" do
    field(:authors, {:array, :string})
    field(:title, :string)
    field(:slug, :string)
    field(:category, :string)
    field(:datetime, :utc_datetime)
    field(:excerpt, :string)
    field(:excerpt_html, :string, default: "")
    field(:body, :string)
    field(:body_html, :string, default: "")
    field(:tags, {:array, :string}, default: [])
  end

  @all_fields [
    :excerpt,
    :excerpt_html,
    :body,
    :body_html,
    :excerpt_html,
    :authors,
    :slug,
    :category,
    :datetime,
    :title,
    :tags
  ]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> validate_required([
      :authors,
      :body,
      :body_html,
      :category,
      :datetime,
      :tags,
      :title,
      :slug
    ])
  end
end
