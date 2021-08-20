defmodule Erlef.Blog.Version do
  @moduledoc """
  Schema for blog versions.

  Used to embed collections of changes (versions) to blog posts.
  """
  use Ecto.Schema

  embedded_schema do
    field(:changes, :map)
    belongs_to(:changed_by, Erlef.Accounts.Member, type: :binary_id)
    timestamps()
  end
end
