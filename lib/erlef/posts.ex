defmodule Erlef.Posts do
  import Ecto.Query
  alias Erlef.Repo

  def all(schema) do
    schema |> order_by([x], x.datetime) |> Repo.all()
  end

  def get_by_slug(schema, slug) do
    case Repo.get_by(schema, slug: slug) do
      %{slug: ^slug} = post -> {:ok, post}
      _ -> {:error, :not_found}
    end
  end

  def get_by_category(schema, cat) do
    schema |> where([x], x.category == ^cat) |> Repo.all()
  end
end
