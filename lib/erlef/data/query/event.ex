defmodule Erlef.Data.Query.Event do
  @moduledoc """
  Module for the event queries
  """
  import Ecto.Query, only: [from: 2]

  alias Erlef.Data.Schema.Event
  alias Erlef.Data.Repo

  @doc """
  Returns a event by slug.
  """
  @spec get_by_slug(slug :: binary(), repo :: Ecto.Repo.t()) :: Event.t() | nil
  def get_by_slug(slug, repo \\ Repo) do
    from(p in Event,
      where: p.slug == ^slug,
      preload: [:event_type],
      limit: 1
    )
    |> repo.one()
  end

  @doc """
  Returns all approved events
  """
  @spec approved(repo :: Ecto.Repo.t()) :: [Event.t()]
  def approved(repo \\ Repo) do
    from(p in Event,
      where: p.approved,
      where: p.start >= ^Date.utc_today(),
      order_by: [p.start, p.title],
      preload: [:event_type]
    )
    |> repo.all()
  end
end
