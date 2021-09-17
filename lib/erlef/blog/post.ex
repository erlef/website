defmodule Erlef.Blog.Post do
  use Erlef.Schema

  alias Erlef.Blog

  schema "blog_posts" do
    field(:title, :string)
    field(:slug, :string)
    field(:excerpt, :string)
    field(:body, :string)
    field(:authors, {:array, :string})
    field(:category, :string)
    field(:tags, {:array, :string}, default: [])
    field(:status, Ecto.Enum, values: [:published, :archived])
    field(:published_at, :utc_datetime)

    belongs_to(:owner, Erlef.Accounts.Member)


    timestamps()
  end

  @required_fields [
    :title,
    :body,
    :category,
    :authors,
    :status,
    :owner_id
  ]

  @optional_fields [
    :excerpt,
    :tags
  ]

  @all_fields @required_fields ++ @optional_fields

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_category()
    |> published_at()
    |> slugify()
    end

    defp validate_category(%{changes: %{category: cat}} = cs) do
      #TO-DO
      IO.inspect(cs)
    end

    defp validate_category(cs), do: cs

    defp published_at(%{changes: %{status: :published}} = cs) do
      put_change(cs, :published_at, time_now())
    end

    defp published_at(cs), do: cs

    defp time_now(), do: DateTime.truncate(DateTime.utc_now(), :second)

    defp slugify(%{changes: %{title: title}} = cs) do
      #TO-DO handle the case of conflicting slugs
      put_change(cs, :slug, Slug.slugify(title))
    end

    defp slugify(cs), do: cs
end
