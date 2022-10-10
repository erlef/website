defmodule ErlefWeb.JobController.UpdatePostForm do
  @moduledoc """
  An embedded Ecto schema for validation and normalization of a form for post
  updates.
  """

  use Ecto.Schema

  alias Erlef.Jobs.URIType
  alias Erlef.Jobs.Post

  import Ecto.Changeset

  @required_fields [:title, :description, :position_type, :website]
  @optional_fields [:approved, :city, :region, :country, :remote]
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
  end

  @doc """
  Returns a changeset for updating a particular post.
  """
  @spec for_post(Post.t()) :: term()
  def for_post(%Post{} = post) do
    # This is the place where a mapping between the post and this module's
    # struct should be performed.
    post_map = Map.from_struct(post)

    changeset(%__MODULE__{}, post_map)
  end

  def changeset(request \\ %__MODULE__{}, attrs \\ %{}) do
    request
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
