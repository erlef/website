defmodule Erlef.Posts do
  import Ecto.Query
  alias Erlef.Repo

  def all(schema) do
    schema |> Repo.all() |> sort_by_datetime()
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

  defp sort_by_datetime(posts) do
    Enum.sort(
      posts,
      fn p1, p2 ->
        DateTime.compare(p1.datetime, p2.datetime) == :gt
      end
    )
  end
end
