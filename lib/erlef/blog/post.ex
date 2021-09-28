defmodule Erlef.Blog.Post do
  use Erlef.Schema

  alias Erlef.Blog

  schema "blog_posts" do
    field(:title, :string)
    field(:slug, :string)
    field(:excerpt, :string)
    field(:body, :string)
    field(:authors, {:array, :string}, default: [])
    field(:category, :string)
    field(:tags, {:array, :string}, default: [])
    field(:status, Ecto.Enum, values: [:draft, :published, :archived], default: :draft)
    field(:published_at, :utc_datetime)

    embeds_many(:post_versions, PostVersion) do
      field(:title, :string)
      field(:excerpt, :string)
      field(:body, :string)
      field(:authors, {:array, :string})
      field(:category, :string)
      field(:tags, {:array, :string})
      field(:status, Ecto.Enum, values: [:draft, :published, :archived])
      field(:updated_by, Ecto.UUID)
      timestamps()
    end

    belongs_to(:owner, Erlef.Accounts.Member)

    timestamps()
  end

  @required_fields [
    :title,
    :body,
    :category,
    :authors,
    :owner_id
  ]

  @optional_fields [
    :excerpt,
    :status,
    :tags
  ]

  @all_fields @required_fields ++ @optional_fields

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_length(:authors, min: 1)
    |> published_at()
    |> sanitize_body()
    |> slugify()
    |> maybe_save_post_version(attrs)
  end

  defp published_at(%{changes: %{status: :published}} = cs) do
    put_change(cs, :published_at, time_now())
  end

  defp published_at(cs), do: cs

  defp time_now(), do: DateTime.truncate(DateTime.utc_now(), :second)

  defp slugify(%{changes: %{title: title}} = cs) do
    slug = Slug.slugify(title)

    case Blog.get_post_by_slug(slug) do
      {:ok, post} ->
        if post.id != Map.get(cs.data, :id) do
          add_error(cs, :title, "Title must be unique")
        else
          put_change(cs, :slug, slug)
        end

      {:error, :not_found} ->
        put_change(cs, :slug, slug)
    end
  end

  defp slugify(cs), do: cs

  defp sanitize_body(%{changes: %{body: body}} = cs) do
    put_change(cs, :body, HtmlSanitizeEx.strip_tags(body))
  end

  defp sanitize_body(cs), do: cs

  defp maybe_save_post_version(%{data: %{id: nil}} = cs, _params), do: cs

  defp maybe_save_post_version(cs, %{"updated_by" => updated_by}) do
    maybe_save_post_version(cs, %{updated_by: updated_by})
  end

  defp maybe_save_post_version(%{changes: changes} = cs, %{updated_by: updated_by}) do
    if map_size(changes) != 0 do
      versions = cs.data.post_versions || []

      ver = %Erlef.Blog.Post.PostVersion{
        title: cs.data.title,
        excerpt: cs.data.excerpt,
        body: cs.data.body,
        authors: cs.data.authors,
        category: cs.data.category,
        tags: cs.data.tags,
        status: cs.data.status,
        updated_by: updated_by
      }

      put_embed(cs, :post_versions, Enum.take([ver | versions], 9))
    else
      cs
    end
  end

  defp maybe_save_post_version(cs, _params), do: cs
end
