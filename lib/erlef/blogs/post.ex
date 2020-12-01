defmodule Erlef.Blogs.Post do
  @moduledoc """
  Erlef.Blog schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "blogs" do
    field(:author, :string)
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

  @required_fields [
    :excerpt,
    :excerpt_html,
    :body,
    :body_html,
    :excerpt_html,
    :author,
    :slug,
    :category,
    :datetime,
    :title
  ]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ [:tags])
  end
end
