defmodule Erlef.Query.Event do
  @moduledoc """
  Module for the event queries
  """
  import Ecto.Query, only: [from: 2]

  alias Erlef.Schema.Event
  alias Erlef.Repo

  @doc """
  Returns a event given a valid id
  """
  @spec get(id :: Ecto.UUID.t(), repo :: Ecto.Repo.t()) :: Event.t() | nil
  def get(id, repo \\ Repo) do
    repo.get(Event, id)
  end

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

  @doc """
  Returns all unapproved events
  """
  @spec unapproved(repo :: Ecto.Repo.t()) :: [Event.t()]
  def unapproved(repo \\ Repo) do
    from(p in Event,
      where: p.approved == false,
      order_by: [p.inserted_at],
      preload: [:event_type]
    )
    |> repo.all()
  end

  @spec unapproved_count(repo :: Ecto.Repo.t()) :: [Event.t()]
  def unapproved_count(repo \\ Repo) do
    from(p in Event,
      where: p.approved == false,
      select: count(p.id)
    )
    |> repo.one()
  end
end
