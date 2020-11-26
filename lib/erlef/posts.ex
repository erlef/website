defmodule Erlef.Posts do
  @moduledoc """
  Erlef.Posts context
  """

  import Ecto.Query
  alias Erlef.Repo.ETS

  def all(schema) do
    schema |> ETS.all()
  end

  def get_by_slug(schema, slug) do
    case ETS.get_by(schema, slug: slug) do
      %{slug: ^slug} = post -> {:ok, post}
      _ -> {:error, :not_found}
    end
  end

  def get_by_category(schema, cat) do
    schema |> where([x], x.category == ^cat) |> ETS.all()
  end

  def sort_by_datetime(posts) do
    Enum.sort(
      posts,
      fn p1, p2 ->
        DateTime.compare(p1.datetime, p2.datetime) == :gt
      end
    )
  end
end
