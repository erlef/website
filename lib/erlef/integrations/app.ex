defmodule Erlef.Integrations.App do
  @moduledoc false

  use Erlef.Schema

  alias Erlef.Integrations.AppKey

  schema "apps" do
    field(:name, :string)
    field(:slug, :string)
    field(:client_id, Ecto.UUID, autogenerate: true)
    field(:created_by, Ecto.UUID)
    field(:updated_by, Ecto.UUID)
    field(:enabled, :boolean, default: false)
    has_many(:keys, AppKey)
    timestamps()
  end

  @required [:name, :created_by]
  @optional [:enabled, :updated_by]
  @permitted @required ++ @optional

  @doc false
  def changeset(app, attrs) do
    app
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> slugify()
  end

  defp slugify(%{changes: %{name: name}} = cs) do
    put_change(cs, :slug, Slug.slugify(name))
  end

  defp slugify(cs), do: cs

  def get_by_slug(slug) do
    from(a in __MODULE__,
      left_join: k in assoc(a, :keys),
      where: a.slug == ^slug,
      preload: [keys: k]
    )
  end

  def get_with_keys(id) do
    from(a in __MODULE__,
      left_join: k in assoc(a, :keys),
      where: a.id == ^id,
      preload: [keys: k]
    )
  end
end
