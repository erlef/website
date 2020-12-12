defmodule Erlef.Community.Query do
  @moduledoc """
  Module for the event queries
  """
  import Ecto.Query, only: [from: 2]

  alias Erlef.Community.Event
  alias Erlef.Repo

  @doc """
  Returns a event given a valid id
  """
  @spec get_event(id :: Ecto.UUID.t(), repo :: Ecto.Repo.t()) :: Event.t() | nil
  def get_event(id, repo \\ Repo) do
    repo.get(Event, id)
  end

  @doc """
  Returns a event by slug.
  """
  @spec get_event_by_slug(slug :: binary(), repo :: Ecto.Repo.t()) :: Event.t() | nil
  def get_event_by_slug(slug, repo \\ Repo) do
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
  @spec approved_events(repo :: Ecto.Repo.t()) :: [Event.t()]
  def approved_events(repo \\ Repo) do
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
  @spec unapproved_events(repo :: Ecto.Repo.t()) :: [Event.t()]
  def unapproved_events(repo \\ Repo) do
    from(p in Event,
      where: p.approved == false,
      order_by: [p.inserted_at],
      preload: [:event_type]
    )
    |> repo.all()
  end

  @spec unapproved_events_count(repo :: Ecto.Repo.t()) :: [Event.t()]
  def unapproved_events_count(repo \\ Repo) do
    from(p in Event,
      where: p.approved == false,
      select: count(p.id)
    )
    |> repo.one()
  end
end
